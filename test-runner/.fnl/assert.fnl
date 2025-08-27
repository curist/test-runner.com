(local fennel (require :fennel))

(local assert {})
(set assert.state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file nil})

(fn deep-equal [a b]
  (if (and (= (type a) :table) (= (type b) :table))
      (let [a-keys (icollect [k _ (pairs a)] k)
            b-keys (icollect [k _ (pairs b)] k)]
        (and (= (length a-keys) (length b-keys))
             (accumulate [res true k _ (pairs a)]
               (and res (deep-equal (. a k) (. b k))))))
      (= a b)))

(fn update-group-counts [passed?]
  "Update current group's assertion counts in real-time"
  (when assert.state.current-group
    (if passed?
        (do
          (set assert.state.current-group.passed (+ assert.state.current-group.passed 1))
          (set assert.state.current-group.total (+ assert.state.current-group.total 1)))
        (do
          (set assert.state.current-group.failed (+ assert.state.current-group.failed 1))
          (set assert.state.current-group.total (+ assert.state.current-group.total 1))))))


(fn find-error-level []
  "Find the appropriate stack level for error() to point to test code"
  (var level 1)
  (var found-level nil)
  (while (and (not found-level) level)
    (let [info (debug.getinfo level "Sl")]
      (if (and info info.source)
          (let [source info.source
                clean-source (if (= (string.sub source 1 1) "@")
                                 (string.sub source 2)
                                 source)]
            (if (string.match clean-source "_test%.fnl$")
                (set found-level level)
                (set level (+ level 1))))
          (set level nil))))
  (or found-level 2))

(fn handle-assertion [passed? error-message]
  "Common assertion handler that updates counters and throws on failure"
  (if passed?
      (do
        (set assert.state.passed (+ assert.state.passed 1))
        (update-group-counts true))
      (do
        (set assert.state.failed (+ assert.state.failed 1))
        (update-group-counts false)
        ;; Capture complete context at source - no need for pattern matching later
        (let [test-file (or assert.state.current-file "unknown")
              ;; Get line number directly from debug info, walking up the stack
              line-number (do
                            (var level 2) ;; Start at level 2 to skip handle-assertion itself
                            (var found-line nil)
                            (while (and (not found-line) level (< level 15))
                              (let [info (debug.getinfo level "Sl")]
                                (if (and info info.source info.currentline)
                                    (let [source info.source
                                          clean-source (if (= (string.sub source 1 1) "@")
                                                           (string.sub source 2)
                                                           source)]
                                      ;; Look for test files or any .fnl files not in the framework
                                      (if (or (string.match clean-source "_test%.fnl$")
                                              (and (string.match clean-source "%.fnl$")
                                                   (not (string.match clean-source "/zip/"))
                                                   (not (string.match clean-source "^%./"))))
                                          (set found-line info.currentline)
                                          (set level (+ level 1))))
                                    (set level (+ level 1)))))
                            (or found-line "?"))
              ;; Add test context if available  
              test-context (if assert.state.current-group
                               (.. " (" assert.state.current-group.description ")")
                               "")
              ;; Build complete error message with all context
              complete-message (.. error-message test-context " at " test-file ":" line-number)
              ;; Find appropriate stack level to point error to test code
              error-level (find-error-level)]
          (error complete-message error-level)))))

(fn assert.ok [v ?message]
  (handle-assertion v (or ?message "assertion failed")))

(fn assert.falsy [v ?message]
  "Asserts that a value is falsy (nil or false)."
  (handle-assertion (not v) (or ?message (.. (tostring v) " is not falsy"))))

(fn assert.= [a b]
  (handle-assertion (= a b) (.. (tostring a) " is not equal to " (tostring b))))

(fn assert.not= [a b]
  (handle-assertion (not (= a b)) (.. (tostring a) " is equal to " (tostring b))))

(fn assert.nil? [v]
  (handle-assertion (= nil v) (.. (tostring v) " is not nil")))

(fn assert.deep= [a b]
  (handle-assertion (deep-equal a b)
    (.. "\n  " (fennel.view a)
        "\n  is not deeply equal to\n  "
        (fennel.view b))))

(fn assert.match [pattern text]
  "Asserts that text contains the given pattern using Lua string.find"
  (handle-assertion (string.find text pattern)
    (.. "Pattern '" pattern "' not found in text: " (tostring text))))

(fn assert.throws [test-fn ?pattern]
  "Asserts that calling test-fn throws an error, optionally matching a pattern"
  (let [(ok? err) (pcall test-fn)]
    (if ok?
        (handle-assertion false "Expected function to throw an error, but it succeeded")
        (if ?pattern
            (handle-assertion (string.find err ?pattern)
              (.. "Error message '" err "' does not match pattern '" ?pattern "'"))
            (handle-assertion true)))))



(fn assert.testing [description test-fn]
  "Collects test functions for later parallel execution with descriptive grouping"
  ;; Error if we're already inside a testing block (nested testing not supported)
  (when assert.state.current-group
    (error (.. "Nested assert.testing calls are not supported. Found '" description 
               "' inside '" assert.state.current-group.description "'") 2))
  (let [test-entry {: description
                    : test-fn}]
    ;; Collect the test for later execution instead of running it now
    (table.insert assert.state.collected-tests test-entry)
    ;; Return a placeholder result for compatibility
    test-entry))

(fn assert.execute-collected-tests []
  "Execute all collected testing functions in parallel and return organized results"
  (let [future (require :future)
        test-tasks (icollect [_ test-entry (ipairs assert.state.collected-tests)]
                     (future.async 
                       #(let [;; Create isolated state for this forked process
                              isolated-state {:passed 0 :failed 0 :groups [] :current-group nil :collected-tests [] :current-file assert.state.current-file}
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
                          (set assert.state isolated-state)
                          (set assert.state.current-group group-result)
                          ;; Execute the test function
                          (test-entry.test-fn)
                          ;; Capture results from isolated state
                          (let [end-time (get-time-ms)
                                duration (- end-time start-time)]
                            (set group-result.passed assert.state.passed)
                            (set group-result.failed assert.state.failed)
                            (set group-result.total (+ assert.state.passed assert.state.failed))
                            (set group-result.duration duration)
                            ;; Return the group result (this gets sent back to parent process)
                            group-result))))
        ;; Wait for all tests to complete and collect results
        results (icollect [_ task (ipairs test-tasks)]
                  (task:await))]
    ;; Accumulate total passed/failed counts from all parallel results
    (each [_ result (ipairs results)]
      (set assert.state.passed (+ assert.state.passed result.passed))
      (set assert.state.failed (+ assert.state.failed result.failed)))
    ;; Clear collected tests for next run
    (set assert.state.collected-tests [])
    ;; Store results in groups for display
    (set assert.state.groups results)
    results))

(fn assert.get-results []
  assert.state)

(fn assert.reset []
  (set assert.state.passed 0)
  (set assert.state.failed 0)
  (set assert.state.groups [])
  (set assert.state.current-group nil)
  (set assert.state.collected-tests [])
  (set assert.state.current-file nil))

(fn assert.restore-state [state]
  "Restore assert state from a previous get-results snapshot"
  (set assert.state.passed state.passed)
  (set assert.state.failed state.failed)
  (set assert.state.groups (icollect [_ group (ipairs state.groups)] group))
  (set assert.state.current-group state.current-group))

assert
