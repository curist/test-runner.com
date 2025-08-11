(local assert (require :assert))
(local {: testing} assert)

(fn test-equal-operator []
  (assert.= 1 1)
  (assert.= "hello" "hello")
  (assert.= true true))

(fn test-not-equal-operator []
  (assert.not= 1 2)
  (assert.not= "hello" "world")
  (assert.not= true false))

(fn test-nil-operator []
  (assert.nil? nil))

(fn test-ok-operator []
  (assert.ok true)
  (assert.ok 1)
  (assert.ok "hello"))

(fn test-ok-operator-with-message []
  (let [(ok? err) (pcall (fn [] (assert.ok false "this should fail")))]
    (assert.ok (not ok?))
    (assert.ok (string.find err "this should fail"))))

(fn test-deep-equal-operator []
  (assert.deep= {:a 1 :b 2} {:a 1 :b 2})
  (assert.deep= {:a 1 :b {:c 3}} {:a 1 :b {:c 3}}))

(fn test-testing-function []
  ;; Test that testing function collects tests correctly
  ;; Since we now use parallel execution, we test the collection mechanism
  (let [old-collected-tests assert.state.collected-tests
        _ (set assert.state.collected-tests [])
        _ (testing "sample group" #(do (assert.= 1 1) (assert.ok true) (assert.nil? nil)))
        collected (icollect [_ test (ipairs assert.state.collected-tests)] test)]
    ;; Verify the collection worked
    (assert.= 1 (length collected))
    (assert.= "sample group" (. collected 1 :description))
    ;; Execute the collected test and verify results
    (let [results (assert.execute-collected-tests)
          result (. results 1)]
      (assert.= "sample group" result.description)
      (assert.= 3 result.passed)
      (assert.= 0 result.failed)
      (assert.= 3 result.total))
    ;; Restore state
    (set assert.state.collected-tests old-collected-tests)))

(fn test-testing-with-failures []
  ;; Test that assertion failures propagate correctly from testing blocks
  ;; We verify this by checking that pcall catches the errors properly
  (let [;; Test basic assertion failure propagation
        (ok1? err1) (pcall assert.= 1 2)
        ;; Test that errors are caught when assertions fail
        error-contains-expected-message? (string.find err1 "1 is not equal to 2")]
    ;; Verify the failure was caught and has the right message
    (assert.ok (not ok1?))
    (assert.ok error-contains-expected-message?)))

(fn test-testing-nested-error []
  ;; Test that nested assert.testing calls throw an error
  ;; Save current state
  (let [old-collected assert.state.collected-tests
        old-current-group assert.state.current-group
        _ (set assert.state.collected-tests [])
        _ (set assert.state.current-group nil)]
    ;; Collect the outer test
    (testing "outer" #(testing "inner" #(assert.ok true)))
    ;; Execute and verify it fails with nested error
    (let [(ok? err) (pcall assert.execute-collected-tests)]
      (assert.ok (not ok?))
      (assert.ok (string.find err "Nested assert.testing calls are not supported"))
      (assert.ok (string.find err "Found 'inner' inside 'outer'")))
    ;; Restore state
    (set assert.state.collected-tests old-collected)
    (set assert.state.current-group old-current-group)))


(fn test-match-operator []
  "Test assert.match function with various patterns"
  (assert.match "hello" "hello world")
  (assert.match "wor" "hello world")
  (assert.match "%d+" "test 123 string")
  (assert.match "^start" "start of line")
  (assert.match "end$" "line end"))
   
(fn test-match-operator-failure []
  "Test that assert.match fails appropriately"
  (let [(ok? err) (pcall assert.match "not found" "hello world")]
    (assert.ok (not ok?))
    (assert.ok (string.find err "Pattern 'not found' not found in text: hello world"))))

{: test-equal-operator
 : test-not-equal-operator
 : test-nil-operator
 : test-ok-operator
 : test-ok-operator-with-message
 : test-deep-equal-operator
 : test-testing-function
 : test-testing-with-failures
 : test-testing-nested-error
 : test-match-operator
 : test-match-operator-failure}
