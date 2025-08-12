(local assert (require :assert))
(local test-runner (require :test-runner))
(local mocks (require :mocks))

{:test-walk-finds-test-files
 (fn []
   "Test that walk function finds test files in a directory"
   ;; Note: This test depends on the actual test directory structure
   (let [files (test-runner.walk "test")]
     (assert.ok (> (length files) 0) "Should find test files")
     ;; Check that all found files end with _test.fnl
     (each [_ file (ipairs files)]
       (assert.match "_test%.fnl$" file "All files should be test files"))))

 :test-walk-skips-git-directories
 (fn []
   "Test that walk function skips .git directories"
   (let [files (test-runner.walk ".")]
     ;; Should not find any files in .git directory
     (each [_ file (ipairs files)]
       (assert.falsy (file:match "%.git/") "Should not include .git files"))))

 :test-collect-test-files-with-no-args
 (fn []
   "Test collect-test-files with no arguments walks current directory"
   (let [files (test-runner.collect-test-files [])]
     (assert.ok (> (length files) 0) "Should find test files in current directory")
     ;; Should find our own test files
     (var found-self false)
     (each [_ file (ipairs files)]
       (when (file:match "test_runner_test%.fnl$")
         (set found-self true)))
     (assert.ok found-self "Should find test_runner_test.fnl")))

 :test-collect-test-files-with-directory-arg
 (fn []
   "Test collect-test-files with directory argument"
   (let [files (test-runner.collect-test-files ["test"])]
     (assert.ok (> (length files) 0) "Should find test files in test directory")
     ;; All files should be from test directory
     (each [_ file (ipairs files)]
       (assert.match "^test/" file "All files should be from test directory"))))

 :test-collect-test-files-with-specific-file
 (fn []
   "Test collect-test-files with specific file argument"
   (let [files (test-runner.collect-test-files ["test/assert_test.fnl"])]
     (assert.= 1 (length files) "Should find exactly one file")
     (assert.= "test/assert_test.fnl" (. files 1) "Should be the specified file")))

 :test-collect-test-files-filters-non-fnl-files
 (fn []
   "Test that collect-test-files only accepts .fnl files when specified directly"
   (let [files (test-runner.collect-test-files ["README.md"])]
     (assert.= 0 (length files) "Should not include non-.fnl files")))

 :test-organize-test-results-groups-by-name
 (fn []
   "Test that organize-test-results properly groups results"
   (let [summary-errors [{:name "test1" :ok true :groups [{:description "group1" :passed 1 :failed 0 :total 1}]}
                         {:name "test2" :ok true :groups []}
                         {:name "test1" :ok true :groups [{:description "group2" :passed 2 :failed 0 :total 2}]}]
         organized (test-runner.organize-test-results summary-errors)]
     (assert.ok organized.test-groups "Should have test-groups")
     (assert.ok organized.ungrouped-results "Should have ungrouped-results")
     (assert.= 2 (length (. organized.test-groups "test1")) "test1 should have 2 groups")
     (assert.= 1 (length organized.ungrouped-results) "Should have 1 ungrouped result")))}