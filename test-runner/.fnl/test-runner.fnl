(local rb (require :redbean))
(local future (require :future))
(local assert (require :assert))

(fn get-time-ms []
  "Get current time in milliseconds using high-resolution monotonic clock"
  (let [(seconds nanoseconds) (rb.unix.clock_gettime rb.unix.CLOCK_MONOTONIC)]
    (+ (* seconds 1000) (/ nanoseconds 1000000))))

(fn format-duration [ms]
  "Format duration in milliseconds to human readable format"
  (if (< ms 1000)
      (.. (string.format "%.2f" ms) "ms")
      (.. (string.format "%.2f" (/ ms 1000)) "s")))

(fn walk [dir]
  "Walk directory tree, skipping .git and other non-test directories"
  (let [tests []]
    ;; Skip .git and other system directories
    (when (not (or (dir:match "%.git$")
                   (dir:match "%.jj$")
                   (dir:match "node_modules")
                   (dir:match "artifacts")))
      (each [name kind (rb.unix.opendir dir)]
        (let [path (.. dir "/" name)]
          (if (and (= kind 4)
                   (not (= name "."))
                   (not (= name "..")))
              ;; Recursively walk subdirectories
              (each [_ file (ipairs (walk path))]
                (table.insert tests file))
              ;; Collect test files
              (when (name:match "_test%.fnl$")
                (table.insert tests path))))))
    tests))

(fn run-test-file [file]
  "Runs tests for a single file and returns a summary table."
  (let [suite (require (file:gsub "%.fnl$" ""))
        results {:passed 0 :failed 0 :total 0 :errors [] :groups [] :timings []}]
    (when (= (type suite) :table)
      (let [test-tasks
            (collect [name test-fn (pairs suite)]
              (let [test-name (if (= (type name) :string) name (tostring name))
                    test-to-run (if (= (type name) :string) test-fn (. suite name))]
                (when (and test-to-run (test-name:match "^test-"))
                  (values
                    test-name
                    (future.async
                      #(let [start-time (get-time-ms)]
                         ;; Reset state and clear any previous collected tests
                         (set assert.state.groups [])
                         (set assert.state.collected-tests [])
                         ;; Run test function to collect testing blocks
                         (test-to-run)
                         ;; Execute collected tests in parallel and get results
                         (let [parallel-results (assert.execute-collected-tests)
                               end-time (get-time-ms)
                               duration (- end-time start-time)]
                           {:groups parallel-results :duration duration})))))))]
        (each [name task (pairs test-tasks)]
          (set results.total (+ results.total 1))
          (let [(ok res) (pcall #(task:await))
                name (name:gsub "^test%-" "")]
            (let [test-groups (if (and ok (= (type res) :table) res.groups) 
                                  res.groups 
                                  [])
                  duration (if (and ok (= (type res) :table) res.duration)
                               res.duration
                               0)]
              ;; Record timing information
              (table.insert results.timings
                {:name name :duration duration :file file})
              (if ok
                  (do
                    (set results.passed (+ results.passed 1))
                    (table.insert results.errors
                      {:ok true :name name
                       :groups test-groups :duration duration}))
                  (do
                    (set results.failed (+ results.failed 1))
                    (table.insert results.errors
                      {:ok false :name name :reason res
                       :groups test-groups :duration duration}))))))))
    results))

(fn organize-test-results [summary-errors]
  "Organize test results into grouped and ungrouped categories"
  (let [test-groups {}
        ungrouped-results []]
    (each [_ result (ipairs summary-errors)]
      (let [{: name : groups} result]
        (if (and groups (> (length groups) 0))
            ;; Group the results by test name, preserving duration info
            (do
              (when (not (. test-groups name))
                (set (. test-groups name) []))
              (each [_ group (ipairs groups)]
                ;; Groups now have their own individual timing from assert.fnl
                (table.insert (. test-groups name) group)))
            ;; Keep ungrouped results
            (table.insert ungrouped-results result))))
    {: test-groups : ungrouped-results}))

(fn calculate-median [durations]
  "Calculate median duration from a list of durations"
  (when (> (length durations) 0)
    (let [sorted (doto durations (table.sort))
          len (length sorted)
          mid (math.floor (/ len 2))]
      (if (= (% len 2) 0)
          ;; Even number of elements: average of two middle values
          (/ (+ (. sorted mid) (. sorted (+ mid 1))) 2)
          ;; Odd number of elements: middle value
          (. sorted (+ mid 1))))))

(fn collect-all-durations [organized-results]
  "Collect all test durations from both grouped and ungrouped results"
  (let [durations []]
    (let [{: test-groups : ungrouped-results} organized-results]
      ;; Collect from grouped results
      (each [_ groups (pairs test-groups)]
        (each [_ group (ipairs groups)]
          (when group.duration
            (table.insert durations group.duration))))
      ;; Collect from ungrouped results
      (each [_ result (ipairs ungrouped-results)]
        (when result.duration
          (table.insert durations result.duration))))
    durations))

(fn display-test-results [organized-results colors]
  "Display organized test results with proper formatting"
  (let [{: test-groups : ungrouped-results} organized-results
        {: green : red : reset : yellow} colors
        failed-tests []
        all-durations (collect-all-durations organized-results)
        median-duration (or (calculate-median all-durations) 0)
        ;; Show timing for tests > 2x median OR > 5ms
        threshold (math.max (* median-duration 2) 5)]
    ;; Display grouped results with headers
    (each [test-name groups (pairs test-groups)]
      (print (.. "▼ " test-name))
      (each [_ group (ipairs groups)]
        (let [group-status (if (> group.failed 0) "FAIL" "PASS")
              group-color (if (> group.failed 0) red green)
              indent "  "
              duration (or group.duration 0)
              timing-info (if (> duration threshold)
                              (.. " " yellow (format-duration duration) reset)
                              "")]
          (print (.. indent "[" group-color group-status reset "] " 
                     group.description 
                     " (" group.passed "/" group.total ")" timing-info)))))

    ;; Display ungrouped results  
    (each [_ result (ipairs ungrouped-results)]
      (let [{: name : duration} result
            duration-str (if duration (format-duration duration) "")
            timing-info (if (and duration (> duration threshold))
                            (.. " " yellow duration-str reset)
                            "")]
        (if result.ok
            (print (.. "[" green "PASS" reset "] " name timing-info))
            (let [{: reason} result]
              (print (.. "[" red "FAIL" reset "] " name timing-info))
              (print (.. "  " reason))
              (table.insert failed-tests {: name : reason})))))
    failed-tests))


(fn display-summary [test-results failed-tests colors total-duration]
  "Display final test summary and exit if there are failures"
  (let [{: green : red : reset : gray} colors
        failed (length failed-tests)
        total (length test-results)
        passed (- total failed)
        duration-str (format-duration total-duration)]
    (print)
    (if (= failed 0)
        (print (.. "(" green passed reset "/" total ") "
                   gray duration-str reset))
        (print (.. "(" red passed reset "/" total ") "
                   gray duration-str reset)))
    (when (> failed 0)
      (print "\nFailed tests:")
      (each [_ failure (ipairs failed-tests)]
        (print (.. "- " failure.name ": " failure.reason)))
      (os.exit 1))))

(fn run-tests [tests]
  (assert.reset)
  (let [start-time (get-time-ms)
        test-tasks (icollect [_ file (ipairs tests)]
                     (future.async #(run-test-file file)))
        colors {:green "\27[1;32m" :red "\27[1;31m" :reset "\27[0m"
                :gray "\27[90m" :yellow "\27[0;33m"}
        test-results []
        all-failed-tests []]
    (each [i file (ipairs tests)]
      (print)
      (print file)
      (let [task (. test-tasks i)
            summary (task:await)]
        ;; Collect overall test results
        (each [_ result (ipairs summary.errors)]
          (table.insert test-results result.ok))
        ;; Organize and display results for this file
        (let [organized (organize-test-results summary.errors)
              failed-tests (display-test-results organized colors)]
          ;; Accumulate all failed tests
          (each [_ failure (ipairs failed-tests)]
            (table.insert all-failed-tests failure)))))
    ;; Calculate total duration
    (let [end-time (get-time-ms)
          total-duration (- end-time start-time)]
      ;; Display final summary
      (display-summary test-results all-failed-tests colors total-duration))))

(fn collect-test-files [args]
  (var tests [])
  (if (= 0 (length args))
      (set tests (walk "."))
      (each [_ path (ipairs args)]
        (let [(stat err) (rb.unix.stat path)]
          (if err
              (error (.. "invalid filepath: " path))
              (if (and stat (rb.unix.S_ISDIR (stat:mode)))
                  (each [_ file (ipairs (walk path))]
                    (table.insert tests file))
                  ;; Add any .fnl file when explicitly specified
                  (when (path:match "%.fnl$")
                    (table.insert tests path)))))))
  tests)

;; Export module functions for testing and external use
{: walk
 : run-test-file
 : organize-test-results
 : display-test-results
 : display-summary
 : run-tests
 : collect-test-files
 : get-time-ms
 : format-duration}
