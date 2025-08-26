(local assert (require :assert))
(local test-runner (require :test-runner))

{:test-organize-test-results-with-groups
 (fn []
   "Test organize-test-results with grouped results"
   (let [summary-errors [{:name "test1" :ok true :groups [{:description "group1" :passed 1 :failed 0 :total 1}]}
                         {:name "test2" :ok true :groups []}
                         {:name "test1" :ok true :groups [{:description "group2" :passed 2 :failed 0 :total 2}]}]
         organized (test-runner.organize-test-results summary-errors)]
     (assert.ok organized.test-groups "Should have test-groups")
     (assert.ok organized.ungrouped-results "Should have ungrouped-results")
     (assert.= 2 (length (. organized.test-groups "test1")) "test1 should have 2 groups")
     (assert.= 1 (length organized.ungrouped-results) "Should have 1 ungrouped result")))

 :test-organize-test-results-ungrouped-only
 (fn []
   "Test organize-test-results with only ungrouped results"
   (let [summary-errors [{:name "test1" :ok true :groups []}
                         {:name "test2" :ok false :reason "error" :groups []}]
         organized (test-runner.organize-test-results summary-errors)]
     (var group-count 0)
     (each [_ _ (pairs organized.test-groups)]
       (set group-count (+ group-count 1)))
     (assert.= 0 group-count "Should have no test groups")
     (assert.= 2 (length organized.ungrouped-results) "Should have 2 ungrouped results")))

 :test-organize-test-results-empty-input
 (fn []
   "Test organize-test-results with empty input"
   (let [organized (test-runner.organize-test-results [])]
     (assert.ok organized.test-groups "Should have test-groups table")
     (assert.ok organized.ungrouped-results "Should have ungrouped-results table")
     (var group-count 0)
     (each [_ _ (pairs organized.test-groups)]
       (set group-count (+ group-count 1)))
     (assert.= 0 group-count "Should have no test groups")
     (assert.= 0 (length organized.ungrouped-results) "Should have no ungrouped results")))

 :test-organize-test-results-mixed-groups
 (fn []
   "Test organize-test-results with mixed grouped and ungrouped results"
   (let [summary-errors [{:name "grouped-test" :ok true :groups [{:description "group1" :passed 1 :failed 0 :total 1}]}
                         {:name "ungrouped-test" :ok false :reason "failed" :groups []}]
         organized (test-runner.organize-test-results summary-errors)]
     (assert.= 1 (length (. organized.test-groups "grouped-test")) "Should have 1 group for grouped-test")
     (assert.= 1 (length organized.ungrouped-results) "Should have 1 ungrouped result")
     (assert.= "ungrouped-test" (. organized.ungrouped-results 1 :name) "Ungrouped should be ungrouped-test")))}
