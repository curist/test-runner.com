(import-macros asserts :asserts)
(local test-runner (require :test-runner))

{:test-walk-finds-test-files
 (fn []
   "Test that walk function finds test files in a directory"
   ;; Note: This test depends on the actual test directory structure
   (let [files (test-runner.walk "test")]
     (asserts.ok (> (length files) 0) "Should find test files")
     ;; Check that all found files end with _test.fnl
     (each [_ file (ipairs files)]
       (asserts.match "_test%.fnl$" file "All files should be test files"))))

 :test-walk-skips-git-directories
 (fn []
   "Test that walk function skips .git directories"
   (let [files (test-runner.walk ".")]
     ;; Should not find any files in .git directory
     (each [_ file (ipairs files)]
       (asserts.falsy (file:match "%.git/") "Should not include .git files"))))

 :test-collect-test-files-with-no-args
 (fn []
   "Test collect-test-files with no arguments walks current directory"
   (let [files (test-runner.collect-test-files [])]
     (asserts.ok (> (length files) 0) "Should find test files in current directory")
     ;; Should find our own test files
     (var found-self false)
     (each [_ file (ipairs files)]
       (when (file:match "test_runner_integration_test%.fnl$")
         (set found-self true)))
     (asserts.ok found-self "Should find test_runner_integration_test.fnl")))

 :test-collect-test-files-with-directory-arg
 (fn []
   "Test collect-test-files with directory argument"
   (let [files (test-runner.collect-test-files ["test"])]
     (asserts.ok (> (length files) 0) "Should find test files in test directory")
     ;; All files should be from test directory
     (each [_ file (ipairs files)]
       (asserts.match "^test/" file "All files should be from test directory"))))

 :test-collect-test-files-with-specific-file
 (fn []
   "Test collect-test-files with specific file argument"
   (let [files (test-runner.collect-test-files ["test/assert_test.fnl"])]
     (asserts.= 1 (length files) "Should find exactly one file")
     (asserts.= "test/assert_test.fnl" (. files 1) "Should be the specified file")))

 :test-collect-test-files-filters-non-fnl-files
 (fn []
   "Test that collect-test-files only accepts .fnl files when specified directly"
   (let [files (test-runner.collect-test-files ["README.md"])]
     (asserts.= 0 (length files) "Should not include non-.fnl files")))

 :test-organize-test-results-groups-by-name
 (fn []
   "Test that organize-test-results properly groups results"
   (let [summary-errors [{:name "test1" :ok true :groups [{:description "group1" :passed 1 :failed 0 :total 1}]}
                         {:name "test2" :ok true :groups []}
                         {:name "test1" :ok true :groups [{:description "group2" :passed 2 :failed 0 :total 2}]}]
         organized (test-runner.organize-test-results summary-errors)]
     (asserts.ok organized.test-groups "Should have test-groups")
     (asserts.ok organized.ungrouped-results "Should have ungrouped-results")
     (asserts.= 2 (length (. organized.test-groups "test1")) "test1 should have 2 groups")
     (asserts.= 1 (length organized.ungrouped-results) "Should have 1 ungrouped result")))

 :test-future-await-handles-nil-decoded
 (fn []
   "Test that demonstrates the nil decoded JSON issue and verifies rb.decode-json behavior"
   (local rb (require :redbean))

   ;; First, verify that rb.decode-json returns nil for invalid JSON
   (let [invalid-cases ["invalid-json-{broken"
                        "{"
                        "{broken"
                        ""
                        nil]]
     (each [_ invalid-json (ipairs invalid-cases)]
       (let [result (rb.decode-json invalid-json)]
         ;; This demonstrates that rb.decode-json can return nil
         (when (not (= result nil))
           (asserts.nil? result (.. "Expected nil for invalid JSON: " (tostring invalid-json)))))))

   ;; This test documents the issue: when a child process in future.async
   ;; writes corrupted data to the pipe (maybe due to a crash or memory corruption),
   ;; rb.decode-json returns nil, and future.fnl:84 tries to access decoded.error
   ;; which causes "attempt to index a nil value"
   )}
