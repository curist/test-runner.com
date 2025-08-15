;; A simple Future implementation for concurrent tasks using fork/pipe.

(local rb (require :redbean))

(local Future {:__name "Future"})
(set Future.__index Future)

(fn table-is-empty? [t]
  (not (next t)))

(fn is-future? [value]
  "Check if a value is a Future-like object."
  (and (= (type value) "table") 
       (getmetatable value)
       (let [name (. (getmetatable value) :__name)]
         (or (= name "Future")
           (= name "AllFuture")
           (= name "RaceFuture")))))

(fn wait-for-process [pid]
  "Wait for process to exit, handling WNOHANG properly."
  (var status nil)
  (while (not status)
    (set status (rb.unix.wait pid rb.unix.WNOHANG))
    (when (not status)
      (rb.unix.nanosleep 0 1000000))) ;; Sleep 1ms
  status)

(fn Future.async [f]
  "Runs a function in a separate process and returns a future object.
   The provided function `f` should return a single, JSON-serializable value."
  (assert (= (type f) "function") "future.async requires a function")

  (let [(read-fd write-fd) (assert (rb.unix.pipe))
        pid (assert (rb.unix.fork))]
    (if (= 0 pid)
        ;; --- Child (Worker) Process ---
        (do
          (rb.unix.close read-fd) ;; Worker doesn't read
          (let [(ok result) (pcall f)]
            (let [payload (if ok
                              (rb.encode-json {:value result})
                              (rb.encode-json {:error result}))]
              (rb.unix.write write-fd payload)))
          (rb.unix.close write-fd)
          (rb.unix.exit 0))
        ;; --- Parent (Supervisor) Process ---
        (do
          (rb.unix.close write-fd) ;; Parent doesn't write
          (let [self {:pid pid
                      :read_fd read-fd
                      :status :pending
                      :result nil}]
            (setmetatable self Future))))))

(fn Future.await [self timeout-ms]
  "Waits for the future to complete and returns its result.
   This function will block until the worker process finishes or the timeout (in ms) is reached."
  (assert (= (getmetatable self) Future) "await must be called on a Future")
  (if (= self.status :resolved)
      (if self.error
          (error self.error 0)
          self.result)
      (let [;; Use poll to wait for the pipe to be readable
            poll-fds {self.read_fd rb.unix.POLLIN}
            ;; poll timeout is in milliseconds
            timeout (if timeout-ms (math.floor timeout-ms) -1)
            (ok ready-fds) (pcall #(assert (rb.unix.poll poll-fds timeout)))]
        (when (= self.status :cancelled)
          (error "future cancelled"))
        (when (not ok)
          (error "poll failed"))
        (when (table-is-empty? ready-fds)
          (self:cancel)
          (error "timeout"))
        ;; Read and decode the result from the pipe
        (let [payload (assert (rb.unix.read self.read_fd))
              decoded (rb.decode-json payload)]
          ;; --- Cleanup ---
          (rb.unix.close self.read_fd)
          (wait-for-process self.pid)
          ;; --- Cache and return result ---
          (set self.status :resolved)
          (if decoded.error
              (do
                (set self.error decoded.error)
                (error self.error 0))
              (do
                (set self.result decoded.value)
                self.result))))))

(fn Future.cancel [self]
  "Terminates the future's worker process and cleans up resources."
  (assert (= (getmetatable self) Future) "cancel must be called on a Future")
  (if (not= self.status :pending)
      (io.stderr:write "warning: cancelling a future that is not pending\n")
      (do
        (set self.status :cancelled)
        ;; Terminate the process, close the pipe, and reap the zombie
        (rb.unix.kill self.pid rb.unix.SIGTERM)
        (rb.unix.close self.read_fd)
        (wait-for-process self.pid)
        (set self.error "future cancelled"))))

(fn Future.resolve [value]
  "Returns a future that is already resolved with the given value.
   If the value is already a future, it is returned directly."
  (if (is-future? value)
      value
      (let [self {:status :resolved
                  :result value
                  ;; No process or pipe needed
                  :pid nil
                  :read_fd nil}]
        (setmetatable self Future))))

(fn Future.reject [err]
  "Returns a future that is already rejected with the given error."
  (let [self {:status :resolved ;; 'resolved' means completed, not necessarily succeeded
              :error err
              :result nil
              :pid nil
              :read_fd nil}]
    (setmetatable self Future)))


(local AllFuture {:__name "AllFuture"})
(set AllFuture.__index AllFuture)

(fn AllFuture.await [self timeout-ms]
  "Waits for all futures to complete and returns their results."
  (assert (= (getmetatable self) AllFuture) "await must be called on an AllFuture")
  (if (= self.status :resolved)
      (if self.error
          (error self.error)
          self.results)
      (do
        (let [poll-fds {}
              fd-map {}]
          ;; Prepare for polling
          (each [i f (ipairs self.futures)]
            (tset poll-fds f.read_fd rb.unix.POLLIN)
            (tset fd-map f.read_fd i))

          (while (not (table-is-empty? poll-fds))
            (let [timeout (if timeout-ms (math.floor timeout-ms) -1)
                  ready-fds (assert (rb.unix.poll poll-fds timeout))]
              (when (table-is-empty? ready-fds)
                (error "timeout"))
              (each [fd _ (pairs ready-fds)]
                (let [idx (. fd-map fd)
                      f (. self.futures idx)]
                  ;; This will read, decode, cleanup, and cache the result inside f
                  (let [res (f:await)]
                    (tset self.results idx res))
                  ;; Stop polling for this fd
                  (tset poll-fds fd nil))))))

        (set self.status :resolved)
        self.results)))

(fn Future.all [futures]
  "Takes a list of futures and returns a new future that resolves
   when all of them have completed. The result is a list of their results."
  (let [self {:futures futures
              :status :pending
              :results (icollect [_ _ (ipairs futures)] nil)}]
    (setmetatable self AllFuture)))

(fn AllFuture.cancel [self]
  "Cancels all underlying pending futures."
  (assert (= (getmetatable self) AllFuture) "cancel must be called on an AllFuture")
  (when (= self.status :pending)
    (set self.status :cancelled)
    (each [_ f (ipairs self.futures)]
      (when (= f.status :pending)
        (f:cancel)))
    (set self.error "future cancelled")))


(local RaceFuture {:__name "RaceFuture"})
(set RaceFuture.__index RaceFuture)

(fn RaceFuture.cancel [self]
  "Cancels the race and all underlying pending futures."
  (assert (= (getmetatable self) RaceFuture) "cancel must be called on a RaceFuture")
  (when (= self.status :pending)
    (set self.status :cancelled)
    (each [_ f (ipairs self.futures)]
      (when (= f.status :pending)
        (f:cancel)))
    (set self.error "future cancelled")))

(fn RaceFuture.await [self timeout-ms]
  "Waits for the first future to complete, cancels the others, and returns its result."
  (assert (= (getmetatable self) RaceFuture) "await must be called on a RaceFuture")
  (if (= self.status :resolved)
      (if self.error
          (error self.error 0)
          self.result)
      (let [poll-fds {}
            fd-map {}]
        (var winner nil)
        ;; Check for any already-resolved futures first
        (each [_ f (ipairs self.futures) &until winner]
          (when (= f.status :resolved)
            (set winner f)))

        (when (not winner)
          ;; Prepare for polling if no future was already resolved
          (each [i f (ipairs self.futures)]
            (when (= f.status :pending)
              (tset poll-fds f.read_fd rb.unix.POLLIN)
              (tset fd-map f.read_fd i)))

          (let [timeout (if timeout-ms (math.floor timeout-ms) -1)
                (ok ready-fds) (pcall #(assert (rb.unix.poll poll-fds timeout)))]
            (when (= self.status :cancelled)
              (error "future cancelled"))
            (when (not ok)
              (error "poll failed"))
            (when (table-is-empty? ready-fds)
              ;; Timeout occurred, cancel all pending futures
              (each [_ f (ipairs self.futures)]
                (when (= f.status :pending)
                  (f:cancel)))
              (error "timeout"))

            (let [winner-fd (next ready-fds)
                  winner-idx (. fd-map winner-fd)]
              (set winner (. self.futures winner-idx)))))

        ;; Cancel all other pending futures
        (each [_ f (ipairs self.futures)]
          (when (and (not= f winner) (= f.status :pending))
            (f:cancel)))

        ;; Await the winner and set the result for the race future.
        ;; If winner:await() errors, this whole block will error, propagating it up.
        (let [res (winner:await)]
          (set self.status :resolved)
          (set self.result res)
          res))))

(fn Future.race [futures]
  "Takes a list of futures and returns a new future that resolves
   or rejects as soon as the first of them has completed."
  (assert (> (length futures) 0) "race requires at least one future")
  (let [self {:futures futures
              :status :pending
              :result nil
              :error nil}]
    (setmetatable self RaceFuture)))

(fn Future.nanosleep [sec nsec]
  "Returns a future that completes after a specified duration."
  (Future.async (fn [] (rb.unix.nanosleep sec nsec) 0)))

(fn Future.sleep [ms]
  "Returns a future that completes after a specified duration in milliseconds."
  (assert (= (type ms) "number") "sleep requires a number in milliseconds")
  (let [sec (math.floor (/ ms 1000))
        nsec (* (% ms 1000) 1000000)]
    (Future.nanosleep sec nsec)))

Future
