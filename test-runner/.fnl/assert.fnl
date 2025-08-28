;; Regular module - not a macro file
(local fennel (require :fennel))

(local asserts {})
(set asserts.state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file nil})

(fn asserts.deep-equal [a b]
  (if (and (= (type a) :table) (= (type b) :table))
      (let [a-keys (icollect [k _ (pairs a)] k)
            b-keys (icollect [k _ (pairs b)] k)]
        (and (= (length a-keys) (length b-keys))
             (accumulate [res true k _ (pairs a)]
               (and res (asserts.deep-equal (. a k) (. b k))))))
      (= a b)))

(fn update-group-counts [passed?]
  "Update current group's assertion counts in real-time"
  (when asserts.state.current-group
    (if passed?
        (do
          (set asserts.state.current-group.passed (+ asserts.state.current-group.passed 1))
          (set asserts.state.current-group.total (+ asserts.state.current-group.total 1)))
        (do
          (set asserts.state.current-group.failed (+ asserts.state.current-group.failed 1))
          (set asserts.state.current-group.total (+ asserts.state.current-group.total 1))))))



(fn asserts.handle-assertion [passed? error-message]
  "Common assertion handler that updates counters and throws on failure"
  (if passed?
      (do
        (set asserts.state.passed (+ asserts.state.passed 1))
        (update-group-counts true))
      (do
        (set asserts.state.failed (+ asserts.state.failed 1))
        (update-group-counts false)
        ;; Build complete error message with available context
        (let [test-file (or asserts.state.current-file "unknown")
              ;; Add test context if available  
              test-context (if asserts.state.current-group
                               (.. " (" asserts.state.current-group.description ")")
                               "")
              ;; Simple format: focus on test context rather than precise line numbers
              complete-message (.. error-message test-context " in " test-file)]
          (error complete-message 0)))))

;; All assertion functions removed - now handled by asserts-macro.fnl



(fn asserts.testing [description test-fn]
  "Collects test functions for later parallel execution with descriptive grouping"
  ;; Error if we're already inside a testing block (nested testing not supported)
  (when asserts.state.current-group
    (error (.. "Nested asserts.testing calls are not supported. Found '" description 
               "' inside '" asserts.state.current-group.description "'") 2))
  (let [test-entry {: description
                    : test-fn}]
    ;; Collect the test for later execution instead of running it now
    (table.insert asserts.state.collected-tests test-entry)
    ;; Return a placeholder result for compatibility
    test-entry))

(fn asserts.execute-collected-tests []
  "Execute all collected testing functions in parallel and return organized results"
  (let [future (require :future)
        test-tasks (icollect [_ test-entry (ipairs asserts.state.collected-tests)]
                     (future.async 
                       #(let [;; Create isolated state for this forked process
                              isolated-state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file asserts.state.current-file}
                              group-result {:description test-entry.description
                                            :passed 0
                                            :failed 0
                                            :total 0}
                              ;; Get timing function
                              rb (require :redbean)
                              get-time-ms (fn []
                                            (let [(seconds nanoseconds) (rb.unix.clock_gettime rb.unix.CLOCK_MONOTONIC)]
                                              (+ (* seconds 1000) (/ nanoseconds 1000000))))
                              start-time (get-time-ms)]
                          ;; Set up isolated execution context in forked process
                          (set asserts.state isolated-state)
                          (set asserts.state.current-group group-result)
                          ;; Execute the test function
                          (test-entry.test-fn)
                          ;; Capture results from isolated state
                          (let [end-time (get-time-ms)
                                duration (- end-time start-time)]
                            (set group-result.passed asserts.state.passed)
                            (set group-result.failed asserts.state.failed)
                            (set group-result.total (+ asserts.state.passed asserts.state.failed))
                            (set group-result.duration duration)
                            ;; Return the group result (this gets sent back to parent process)
                            group-result))))
        ;; Wait for all tests to complete and collect results
        results (icollect [_ task (ipairs test-tasks)]
                  (task:await))]
    ;; Accumulate total passed/failed counts from all parallel results
    (each [_ result (ipairs results)]
      (set asserts.state.passed (+ asserts.state.passed result.passed))
      (set asserts.state.failed (+ asserts.state.failed result.failed)))
    ;; Clear collected tests for next run
    (set asserts.state.collected-tests [])
    ;; Store results in groups for display
    (set asserts.state.groups results)
    results))

(fn asserts.get-results []
  asserts.state)

(fn asserts.reset []
  (set asserts.state.passed 0)
  (set asserts.state.failed 0)
  (set asserts.state.groups [])
  (set asserts.state.current-group nil)
  (set asserts.state.collected-tests [])
  (set asserts.state.current-file nil))

(fn asserts.restore-state [state]
  "Restore asserts state from a previous get-results snapshot"
  (set asserts.state.passed state.passed)
  (set asserts.state.failed state.failed)
  (set asserts.state.groups (icollect [_ group (ipairs state.groups)] group))
  (set asserts.state.current-group state.current-group))

asserts
