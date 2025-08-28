(local test {})
(set test.state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file nil})

(fn test.deep-equal [a b]
  (if (and (= (type a) :table) (= (type b) :table))
      (let [a-keys (icollect [k _ (pairs a)] k)
            b-keys (icollect [k _ (pairs b)] k)]
        (and (= (length a-keys) (length b-keys))
             (accumulate [res true k _ (pairs a)]
               (and res (test.deep-equal (. a k) (. b k))))))
      (= a b)))

(fn update-group-counts [passed?]
  "Update current group's assertion counts in real-time"
  (when test.state.current-group
    (if passed?
        (do
          (set test.state.current-group.passed (+ test.state.current-group.passed 1))
          (set test.state.current-group.total (+ test.state.current-group.total 1)))
        (do
          (set test.state.current-group.failed (+ test.state.current-group.failed 1))
          (set test.state.current-group.total (+ test.state.current-group.total 1))))))



(fn test.handle-assertion [passed?]
  "Common assertion handler that updates counters and throws on failure"
  (if passed?
      (do
        (set test.state.passed (+ test.state.passed 1))
        (update-group-counts true))
      (do
        (set test.state.failed (+ test.state.failed 1))
        (update-group-counts false))))


(fn test.testing [description test-fn]
  "Collects test functions for later parallel execution with descriptive grouping"
  ;; Error if we're already inside a testing block (nested testing not supported)
  (when test.state.current-group
    (error (.. "Nested test.testing calls are not supported. Found '" description 
               "' inside '" test.state.current-group.description "'") 2))
  (let [test-entry {: description
                    : test-fn}]
    ;; Collect the test for later execution instead of running it now
    (table.insert test.state.collected-tests test-entry)
    ;; Return a placeholder result for compatibility
    test-entry))

(fn test.execute-collected-tests []
  "Execute all collected testing functions in parallel and return organized results"
  (let [future (require :future)
        test-tasks (icollect [_ test-entry (ipairs test.state.collected-tests)]
                     (future.async 
                       #(let [;; Create isolated state for this forked process
                              isolated-state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file test.state.current-file}
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
                          (set test.state isolated-state)
                          (set test.state.current-group group-result)
                          ;; Execute the test function
                          (test-entry.test-fn)
                          ;; Capture results from isolated state
                          (let [end-time (get-time-ms)
                                duration (- end-time start-time)]
                            (set group-result.passed test.state.passed)
                            (set group-result.failed test.state.failed)
                            (set group-result.total (+ test.state.passed test.state.failed))
                            (set group-result.duration duration)
                            ;; Return the group result (this gets sent back to parent process)
                            group-result))))
        ;; Wait for all tests to complete and collect results
        results (icollect [_ task (ipairs test-tasks)]
                  (task:await))]
    ;; Accumulate total passed/failed counts from all parallel results
    (each [_ result (ipairs results)]
      (set test.state.passed (+ test.state.passed result.passed))
      (set test.state.failed (+ test.state.failed result.failed)))
    ;; Clear collected tests for next run
    (set test.state.collected-tests [])
    ;; Store results in groups for display
    (set test.state.groups results)
    results))

(fn test.get-results []
  test.state)

(fn test.reset []
  (set test.state.passed 0)
  (set test.state.failed 0)
  (set test.state.groups [])
  (set test.state.current-group nil)
  (set test.state.collected-tests [])
  (set test.state.current-file nil))

(fn test.restore-state [state]
  "Restore test state from a previous get-results snapshot"
  (set test.state.passed state.passed)
  (set test.state.failed state.failed)
  (set test.state.groups (icollect [_ group (ipairs state.groups)] group))
  (set test.state.current-group state.current-group))

test
