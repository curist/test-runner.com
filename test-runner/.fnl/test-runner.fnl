(local rb (require :redbean))
(local future (require :future))
(local assert (require :assert))

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
        results {:passed 0 :failed 0 :total 0 :errors [] :groups []}]
    (when (= (type suite) :table)
      (let [test-tasks (collect [name test-fn (pairs suite)]
                         (let [test-name (if (= (type name) :string) name (tostring name))
                               test-to-run (if (= (type name) :string) test-fn (. suite name))]
                           (when (and test-to-run (test-name:match "^test-"))
                             (values
                               test-name
                               (future.async
                                 #(do
                                    ;; Reset state and clear any previous collected tests
                                    (set assert.state.groups [])
                                    (set assert.state.collected-tests [])
                                    ;; Run test function to collect testing blocks
                                    (test-to-run)
                                    ;; Execute collected tests in parallel and get results
                                    (let [parallel-results (assert.execute-collected-tests)]
                                      {:groups parallel-results})))))))]
        (each [name task (pairs test-tasks)]
          (set results.total (+ results.total 1))
          (let [(ok res) (pcall #(task:await))
                name (name:gsub "^test%-" "")]
            (let [test-groups (if (and ok (= (type res) :table) res.groups) 
                                  res.groups 
                                  [])]
              (if ok
                  (do
                    (set results.passed (+ results.passed 1))
                    (table.insert results.errors {:ok true :name name :groups test-groups}))
                  (do
                    (set results.failed (+ results.failed 1))
                    (table.insert results.errors {:ok false :name name :reason res :groups test-groups}))))))))
    results))

(fn organize-test-results [summary-errors]
  "Organize test results into grouped and ungrouped categories"
  (let [test-groups {}
        ungrouped-results []]
    (each [_ result (ipairs summary-errors)]
      (let [{: name : groups} result]
        (if (and groups (> (length groups) 0))
            ;; Group the results by test name
            (do
              (when (not (. test-groups name))
                (set (. test-groups name) []))
              (each [_ group (ipairs groups)]
                (table.insert (. test-groups name) group)))
            ;; Keep ungrouped results
            (table.insert ungrouped-results result))))
    {: test-groups : ungrouped-results}))

(fn display-test-results [organized-results colors]
  "Display organized test results with proper formatting"
  (let [{: test-groups : ungrouped-results} organized-results
        {: green : red : reset} colors
        failed-tests []]
    ;; Display grouped results with headers
    (each [test-name groups (pairs test-groups)]
      (print (.. "▼ " test-name))
      (each [_ group (ipairs groups)]
        (let [group-status (if (> group.failed 0) "FAIL" "PASS")
              group-color (if (> group.failed 0) red green)
              indent "  "]
          (print (.. indent "[" group-color group-status reset "] " 
                     group.description 
                     " (" group.passed "/" group.total ")")))))

    ;; Display ungrouped results  
    (each [_ result (ipairs ungrouped-results)]
      (let [{: name} result]
        (if result.ok
            (print (.. "[" green "PASS" reset "] " name))
            (let [{: reason} result]
              (print (.. "[" red "FAIL" reset "] " name))
              (print (.. "  " reason))
              (table.insert failed-tests {: name : reason})))))
    failed-tests))

(fn display-summary [test-results failed-tests colors]
  "Display final test summary and exit if there are failures"
  (let [{: green : red : reset} colors
        failed (length failed-tests)
        total (length test-results)
        passed (- total failed)]
    (print)
    (if (= failed 0)
        (print (.. "(" green passed reset "/" total ")"))
        (print (.. "(" red passed reset "/" total ")")))
    (when (> failed 0)
      (print "\nFailed tests:")
      (each [_ failure (ipairs failed-tests)]
        (print (.. "- " failure.name ": " failure.reason)))
      (os.exit 1))))

(fn run-tests [tests]
  (assert.reset)
  (let [test-tasks (icollect [_ file (ipairs tests)]
                     (future.async #(run-test-file file)))
        colors {:green "\27[1;32m" :red "\27[1;31m" :reset "\27[0m"}
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
    ;; Display final summary
    (display-summary test-results all-failed-tests colors)))

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

(fn show-help []
  "Display help information from embedded USAGE.md"
  (let [usage-content (rb.slurp "/zip/USAGE.md")]
    (if usage-content
        (print usage-content)
        (print "Help documentation not available")))
  (os.exit 0))

(fn show-version []
  "Display version and build information"
  (let [version (rb.slurp "/zip/VERSION.txt")
        redbean-version (or (rb.slurp "/zip/redbean.version.txt") "unknown")]
    (if version
        (print (.. "test-runner.com " (version:gsub "\n" "")))
        (print "test-runner.com (dev)"))
    (print (.. "redbean version: " (redbean-version:gsub "\n" "")))
    (print "fennel version: 1.5.3"))
  (os.exit 0))

(fn parse-flags [args]
  "Parse command line flags and return filtered arguments"
  (let [filtered-args []]
    (each [_ arg (ipairs args)]
      (if (or (= arg "--help") (= arg "-h"))
          (show-help)
          (or (= arg "--version") (= arg "-v"))
          (show-version)
          ;; Check for unknown flags
          (arg:match "^%-")
          (do
            (print (.. "test-runner.com: unknown option '" arg "'"))
            (print "Try 'test-runner.com --help' for more information.")
            (os.exit 1))
          ;; Not a flag, keep it
          (table.insert filtered-args arg)))
    filtered-args))

(-> _G.arg parse-flags collect-test-files run-tests)
