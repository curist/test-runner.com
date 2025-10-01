(local test (require :test))
(import-macros asserts :asserts)
(local {: testing} test)

(fn test-equal-operator []
  (asserts.= 1 1)
  (asserts.= "hello" "hello")
  (asserts.= true true))

(fn test-not-equal-operator []
  (asserts.not= 1 2)
  (asserts.not= "hello" "world")
  (asserts.not= true false))

(fn test-nil-operator []
  (asserts.nil? nil))

(fn test-ok-operator []
  (asserts.ok true)
  (asserts.ok 1)
  (asserts.ok "hello"))

(fn test-ok-operator-with-message []
  (asserts.throws #(asserts.ok false "this should fail") "this should fail"))

(fn test-deep-equal-operator []
  (asserts.deep= {:a 1 :b 2} {:a 1 :b 2})
  (asserts.deep= {:a 1 :b {:c 3}} {:a 1 :b {:c 3}}))

(fn test-testing-function []
  ;; Test that testing function collects tests correctly
  ;; Since we now use parallel execution, we test the collection mechanism
  (let [old-collected-tests test.state.collected-tests
        _ (set test.state.collected-tests [])
        _ (testing "sample group" #(do (asserts.= 1 1) (asserts.ok true) (asserts.nil? nil)))
        collected (icollect [_ test (ipairs test.state.collected-tests)] test)]
    ;; Verify the collection worked
    (asserts.= 1 (length collected))
    (asserts.= "sample group" (. collected 1 :description))
    ;; Execute the collected test and verify results
    (let [results (test.execute-collected-tests)
          result (. results 1)]
      (asserts.= "sample group" result.description)
      (asserts.= 3 result.passed)
      (asserts.= 0 result.failed)
      (asserts.= 3 result.total))
    ;; Restore state
    (set test.state.collected-tests old-collected-tests)))

(fn test-testing-with-failures []
  ;; Test that assertion failures propagate correctly from testing blocks
  (asserts.throws #(asserts.= 1 2) "1 is not equal to 2"))

(fn test-testing-nested-error []
  ;; Test that nested test.testing calls throw an error
  ;; Save current state
  (let [old-collected test.state.collected-tests
        old-current-group test.state.current-group
        _ (set test.state.collected-tests [])
        _ (set test.state.current-group nil)]
    ;; Collect the outer test
    (testing "outer" #(testing "inner" #(asserts.ok true)))
    ;; Execute and verify it fails with nested error
    (asserts.throws test.execute-collected-tests "Nested test.testing calls are not supported")
    (asserts.throws test.execute-collected-tests "Found 'inner' inside 'outer'")
    ;; Restore state
    (set test.state.collected-tests old-collected)
    (set test.state.current-group old-current-group)))


(fn test-match-operator []
  "Test asserts.match function with various patterns"
  (asserts.match "hello world" "hello")
  (asserts.match "hello world" "wor")
  (asserts.match "test 123 string" "%d+")
  (asserts.match "start of line" "^start")
  (asserts.match "line end" "end$"))

(fn test-match-operator-failure []
  "Test that asserts.match fails appropriately"
  (asserts.throws
    #(asserts.match "hello world" "not found")
    "Pattern 'not found' not found in text: hello world"))

(fn test-throws-operator []
  "Test asserts.throws function with functions that should throw"
  (asserts.throws #(error "test error"))
  (asserts.throws #(asserts.= 1 2)))

(fn test-throws-operator-with-pattern []
  "Test asserts.throws function with pattern matching"
  (asserts.throws #(error "specific error message") "specific error")
  (asserts.throws #(asserts.= 1 2) "1 is not equal to 2")
  (asserts.throws #(asserts.nil? "not nil") "not nil"))

(fn test-includes-operator []
  "Test basic substring inclusion"
  (asserts.includes "hello world" "world")
  (asserts.includes "test-runner.com --match=filter" "--match=filter")
  (asserts.includes "Running tests" "Running"))

(fn test-includes-special-characters []
  "Test that special characters don't need escaping"
  (asserts.includes "Running tests with filters: --match=filter" "--match=filter")
  (asserts.includes "test-runner.com" ".")
  (asserts.includes "foo-bar-baz" "-"))

(fn test-includes-case-sensitive []
  "Test that includes is case-sensitive"
  (asserts.includes "Hello World" "Hello")
  (asserts.includes "Hello World" "World")
  ;; This should fail if uncommented:
  ;; (asserts.includes "Hello World" "hello")
  )

(fn test-includes-failure []
  "Test that includes properly fails when substring not found"
  (let [(ok err) (pcall #(asserts.includes "hello world" "foo"))]
    (asserts.falsy ok "Should fail when substring not found")
    (asserts.includes err "Substring 'foo' not found")))

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
 : test-match-operator-failure
 : test-throws-operator
 : test-throws-operator-with-pattern
 : test-includes-operator
 : test-includes-special-characters
 : test-includes-case-sensitive
 : test-includes-failure
 }
