(local test-runner (require :__testrunner__.test-runner))
(import-macros asserts :asserts)

(fn test-should-run-test-no-filters []
  "Test should-run-test? with no filters - all tests should run"
  (asserts.ok (test-runner.should-run-test? "test-foo" [] []))
  (asserts.ok (test-runner.should-run-test? "test-bar" [] []))
  (asserts.ok (test-runner.should-run-test? "test-authentication" [] [])))

(fn test-should-run-test-include-only []
  "Test should-run-test? with include filters only"
  ;; Should match
  (asserts.ok (test-runner.should-run-test? "test-auth-login" ["auth"] []))
  (asserts.ok (test-runner.should-run-test? "test-user-authentication" ["auth"] []))

  ;; Should not match
  (asserts.falsy (test-runner.should-run-test? "test-database-query" ["auth"] []))
  (asserts.falsy (test-runner.should-run-test? "test-foo" ["auth"] [])))

(fn test-should-run-test-exclude-only []
  "Test should-run-test? with exclude filters only"
  ;; Should run (not excluded)
  (asserts.ok (test-runner.should-run-test? "test-fast-unit" [] ["slow"]))
  (asserts.ok (test-runner.should-run-test? "test-authentication" [] ["slow"]))

  ;; Should not run (excluded)
  (asserts.falsy (test-runner.should-run-test? "test-slow-integration" [] ["slow"]))
  (asserts.falsy (test-runner.should-run-test? "test-database-slow-query" [] ["slow"])))

(fn test-should-run-test-combined-filters []
  "Test should-run-test? with both include and exclude filters"
  ;; Include auth, exclude slow
  (asserts.ok (test-runner.should-run-test? "test-auth-fast" ["auth"] ["slow"]))
  (asserts.ok (test-runner.should-run-test? "test-authentication" ["auth"] ["slow"]))

  ;; Excluded even though matches include
  (asserts.falsy (test-runner.should-run-test? "test-auth-slow" ["auth"] ["slow"]))
  (asserts.falsy (test-runner.should-run-test? "test-slow-auth-test" ["auth"] ["slow"]))

  ;; Doesn't match include
  (asserts.falsy (test-runner.should-run-test? "test-database" ["auth"] ["slow"])))

(fn test-should-run-test-case-insensitive []
  "Test should-run-test? with case-insensitive matching"
  ;; Uppercase filter, lowercase test name
  (asserts.ok (test-runner.should-run-test? "test-authentication" ["AUTH"] []))

  ;; Lowercase filter, mixed case test name
  (asserts.ok (test-runner.should-run-test? "test-FastAuth" ["auth"] []))

  ;; Mixed case filter, lowercase test name
  (asserts.ok (test-runner.should-run-test? "test-auth-login" ["AuTh"] []))

  ;; Case insensitive exclude
  (asserts.falsy (test-runner.should-run-test? "test-SlowTest" [] ["SLOW"])))

(fn test-should-run-test-multiple-includes []
  "Test should-run-test? with multiple include filters (OR logic)"
  ;; Should match first include
  (asserts.ok (test-runner.should-run-test? "test-auth-login" ["auth" "database"] []))

  ;; Should match second include
  (asserts.ok (test-runner.should-run-test? "test-database-query" ["auth" "database"] []))

  ;; Should match either
  (asserts.ok (test-runner.should-run-test? "test-auth-database" ["auth" "database"] []))

  ;; Should not match any
  (asserts.falsy (test-runner.should-run-test? "test-network-request" ["auth" "database"] [])))

(fn test-should-run-test-multiple-excludes []
  "Test should-run-test? with multiple exclude filters (OR logic)"
  ;; Should run (matches neither exclude)
  (asserts.ok (test-runner.should-run-test? "test-fast-unit" [] ["slow" "integration"]))

  ;; Should skip (matches first exclude)
  (asserts.falsy (test-runner.should-run-test? "test-slow-query" [] ["slow" "integration"]))

  ;; Should skip (matches second exclude)
  (asserts.falsy (test-runner.should-run-test? "test-integration-test" [] ["slow" "integration"]))

  ;; Should skip (matches both)
  (asserts.falsy (test-runner.should-run-test? "test-slow-integration-test" [] ["slow" "integration"])))

(fn test-should-run-test-prefix-stripping []
  "Test that test- prefix is properly stripped before matching"
  ;; Matching against the part after test-
  (asserts.ok (test-runner.should-run-test? "test-authentication" ["authentication"] []))
  (asserts.ok (test-runner.should-run-test? "test-auth" ["auth"] []))

  ;; Should NOT match if filter includes "test-"
  (asserts.falsy (test-runner.should-run-test? "test-authentication" ["test-auth"] []))

  ;; Partial match should work
  (asserts.ok (test-runner.should-run-test? "test-user-auth-check" ["auth"] [])))

(fn test-should-run-test-literal-substring []
  "Test that matching is literal substring (not pattern/regex)"
  ;; These are literal strings, not patterns
  (asserts.ok (test-runner.should-run-test? "test-foo-bar" ["foo"] []))
  (asserts.ok (test-runner.should-run-test? "test-foo.bar" ["foo."] []))

  ;; Dots should be treated literally
  (asserts.falsy (test-runner.should-run-test? "test-fooXbar" ["foo.bar"] []))
  (asserts.ok (test-runner.should-run-test? "test-foo.bar" ["foo.bar"] [])))

{: test-should-run-test-no-filters
 : test-should-run-test-include-only
 : test-should-run-test-exclude-only
 : test-should-run-test-combined-filters
 : test-should-run-test-case-insensitive
 : test-should-run-test-multiple-includes
 : test-should-run-test-multiple-excludes
 : test-should-run-test-prefix-stripping
 : test-should-run-test-literal-substring}
