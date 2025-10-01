(local rb (require :__testrunner__.redbean))
(local future (require :__testrunner__.future))
(local test (require :test))

(fn should-run-test? [test-name includes excludes]
  "Determine if a test should run based on include/exclude filters.
   Strips 'test-' prefix and performs case-insensitive literal substring matching."
  (let [;; Strip test- prefix and lowercase for matching
        name-without-prefix (test-name:gsub "^test%-" "")
        name-lower (name-without-prefix:lower)]
    ;; Check exclusions first (any exclude match means skip)
    (var should-skip false)
    (each [_ exclude (ipairs excludes)]
      (when (name-lower:find (exclude:lower) 1 true)
        (set should-skip true)))

    (if should-skip
        false
        ;; If includes are specified, name must match at least one
        (if (> (length includes) 0)
            (accumulate [matches false _ inc (ipairs includes)]
              (or matches (not= nil (name-lower:find (inc:lower) 1 true))))
            ;; No includes specified, test runs by default
            true))))

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
      ;; Collect and sort directory entries for deterministic ordering
      (let [entries []]
        (each [name kind (rb.unix.opendir dir)]
          (table.insert entries [name kind]))
        (table.sort entries (fn [a b] (< (. a 1) (. b 1))))
        (each [_ [name kind] (ipairs entries)]
          (let [path (.. dir "/" name)]
            (if (and (= kind 4)
                     (not (= name "."))
                     (not (= name "..")))
                ;; Recursively walk subdirectories
                (each [_ file (ipairs (walk path))]
                  (table.insert tests file))
                ;; Collect test files
                (when (name:match "_test%.fnl$")
                  (table.insert tests path)))))))
    tests))

(fn run-test-file [file options]
  "Runs tests for a single file and returns a summary table.
   options: table with :matches and :excludes arrays for filtering"
  (let [results {:passed 0 :failed 0 :total 0 :errors [] :groups [] :timings []}
        includes (or options.matches [])
        excludes (or options.excludes [])
        ;; Try to load the test file with better error handling
        (load-ok suite) (xpcall #(require (file:gsub "%.fnl$" ""))
                                (fn [err]
                                  (.. "Failed to load " file ":\n" err)))]
    (if (not load-ok)
        ;; Handle load failure gracefully
        (do
          (set results.total 1)
          (set results.failed 1)
          (table.insert results.errors
            {:ok false :name (.. file " (load error)")
             :reason suite :groups [] :duration 0}))
        ;; Process loaded suite
        (when (= (type suite) :table)
          ;; Collect and sort test names for deterministic ordering
          (let [test-names []]
            (each [name test-fn (pairs suite)]
              (let [test-name (if (= (type name) :string) name (tostring name))]
                (when (and test-fn (test-name:match "^test-"))
                  (table.insert test-names test-name))))
            (table.sort test-names)
            ;; Filter test names based on includes/excludes
            (let [filtered-names (icollect [_ name (ipairs test-names)]
                                   (if (should-run-test? name includes excludes)
                                       name))]
              (let [test-tasks
                    (collect [_ name (ipairs filtered-names)]
                      (values
                        name
                        (future.async
                          #(let [start-time (get-time-ms)
                                 test-to-run (. suite name)]
                             ;; Reset state and clear any previous collected tests
                             (set test.state.groups [])
                             (set test.state.collected-tests [])
                             ;; Set current file for error reporting
                             (set test.state.current-file file)
                             ;; Run test function to collect testing blocks
                             (test-to-run)
                             ;; Execute collected tests in parallel and get results
                             (let [parallel-results (test.execute-collected-tests)
                                   end-time (get-time-ms)
                                   duration (- end-time start-time)]
                               {:groups parallel-results :duration duration})))))]
                ;; Iterate in sorted order for deterministic execution
                (each [_ name (ipairs filtered-names)]
                  (let [task (. test-tasks name)]
                    (set results.total (+ results.total 1))
                    (let [(ok res) (pcall #(task:await))
                          name (name:gsub "^test%-" "")]
                      (let [test-groups (if (and ok (= (type res) :table) res.groups)
                                            res.groups
                                            [])
                            duration (if (and ok (= (type res) :table) res.duration)
                                         res.duration
                                         0)
                            ;; Check if any group has failures
                            has-group-failures (accumulate [has-fail false _ group (ipairs test-groups)]
                                                 (or has-fail (> group.failed 0)))]
                        ;; Record timing information
                        (table.insert results.timings
                          {:name name :duration duration :file file})
                        (if (and ok (not has-group-failures))
                            (do
                              (set results.passed (+ results.passed 1))
                              (table.insert results.errors
                                {:ok true :name name
                                 :groups test-groups :duration duration}))
                            (do
                              (set results.failed (+ results.failed 1))
                              (table.insert results.errors
                                {:ok false :name name
                                 :reason (if (not ok) res "Test group(s) had assertion failures")
                                 :groups test-groups :duration duration}))))))))))))
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
                ;; Groups now have their own individual timing from test.fnl
                (table.insert (. test-groups name) group)))
            ;; Keep ungrouped results
            (table.insert ungrouped-results result))))
    {: test-groups : ungrouped-results}))

(fn simplify-error-message [error-message]
  "Extract the relevant test file location from a stack trace"
  (if (error-message:find "stack traceback:")
      ;; Extract just the first relevant line from the stack trace
      (let [lines (icollect [line (error-message:gmatch "[^\n]+")]
                    line)]
        ;; Find the first line that contains a test file path
        (var simplified nil)
        (each [_ line (ipairs lines)]
          (when (and (not simplified) 
                     (line:find "%.fnl:") 
                     (not= line "")
                     (not (line:find "/zip/"))  ;; Skip internal zip paths
                     (not (line:find "in function 'error'")))
            (set simplified line)))
        ;; If we found a relevant line, use it; otherwise fall back to the original
        (if simplified
            (let [;; Extract the main error message (before "stack traceback:")
                  main-msg (error-message:match "^(.-)stack traceback:")
                  ;; Clean up the file line
                  clean-line
                  (-> simplified
                      (: :gsub  "^%s*" "")
                      (: :gsub  "%s*$" "")
                      (: :gsub "^%s*[./]+" "")
                      (: :gsub ": in function.*$" ""))
                  ]
              (.. clean-line "\n" (or main-msg "")))
            error-message))
      ;; No stack trace, return as-is
      error-message))

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
        ;; Show timing for tests > 2x median and > 30ms
        threshold (and (math.max (* median-duration 2) 30))]
    ;; Display grouped results with headers
    (each [test-name groups (pairs test-groups)]
      (print (.. "▼ " test-name))
      (var test-has-failures false)
      (each [_ group (ipairs groups)]
        (let [group-status (if (> group.failed 0) "FAIL" "PASS")
              group-color (if (> group.failed 0) red green)
              indent "  "
              duration (or group.duration 0)
              timing-info (if (> duration threshold)
                              (.. " " yellow (format-duration duration) reset)
                              "")]
          (when (> group.failed 0)
            (set test-has-failures true))
          (print (.. indent "[" group-color group-status reset "] "
                     group.description
                     " (" group.passed "/" group.total ")" timing-info))))
      ;; Add test to failed-tests if any group failed
      (when test-has-failures
        (table.insert failed-tests {:name test-name
                                    :reason "One or more test groups failed"})))

    ;; Display ungrouped results  
    (each [_ result (ipairs ungrouped-results)]
      (let [{: name : duration} result
            duration-str (if duration (format-duration duration) "")
            timing-info (if (and duration (> duration threshold))
                            (.. " " yellow duration-str reset)
                            "")]
        (if result.ok
            (print (.. "[" green "PASS" reset "] " name timing-info))
            (let [{: reason} result
                  simplified-reason (simplify-error-message reason)]
              (print (.. "[" red "FAIL" reset "] " name timing-info))
              (print (.. "  " simplified-reason))
              (table.insert failed-tests {: name :reason simplified-reason})))))
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

(fn run-tests [tests options]
  "Run tests with optional filtering.
   options: table with :matches and :excludes arrays"
  (test.reset)
  (let [start-time (get-time-ms)
        test-results []
        all-failed-tests []
        colors {:green "\27[1;32m" :red "\27[1;31m" :reset "\27[0m"
                :gray "\27[90m" :yellow "\27[0;33m"}
        includes (or options.matches [])
        excludes (or options.excludes [])]
    ;; Display filter info if filters are active
    (when (or (> (length includes) 0) (> (length excludes) 0))
      (let [filter-parts []]
        (each [_ term (ipairs includes)]
          (table.insert filter-parts (.. "--match=" term)))
        (each [_ term (ipairs excludes)]
          (table.insert filter-parts (.. "--no-match=" term)))
        (print (.. "Running tests with filters: " (table.concat filter-parts " ")))
        (print)))
    ;; Run all test files in parallel
    (let [test-tasks (icollect [_ file (ipairs tests)]
                       (future.async #(run-test-file file options)))]
      ;; Process results for all files
      (each [i file (ipairs tests)]
        (let [task (. test-tasks i)
              summary (task:await)]
          ;; Only display file if it has tests that ran
          (when (> (length summary.errors) 0)
            (print)
            (print file)
            ;; Collect overall test results
            (each [_ result (ipairs summary.errors)]
              (table.insert test-results result.ok))
            ;; Organize and display results for this file
            (let [organized (organize-test-results summary.errors)
                  failed-tests (display-test-results organized colors)]
              ;; Accumulate all failed tests
              (each [_ failure (ipairs failed-tests)]
                (table.insert all-failed-tests failure))))))
      ;; Check if any tests were run
      (when (= (length test-results) 0)
        (print "No tests matched the provided filters.")
        (os.exit 0))
      ;; Calculate total duration
      (let [end-time (get-time-ms)
            total-duration (- end-time start-time)]
        ;; Display final summary
        (display-summary test-results all-failed-tests colors total-duration)))))

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
 : format-duration
 : should-run-test?}
