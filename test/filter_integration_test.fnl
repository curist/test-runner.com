(local test (require :test))
(local {: testing} test)
(import-macros asserts :asserts)

(fn run-with-filters [args]
  "Helper to run test-runner.com with given arguments and capture output"
  (let [cmd (.. "./artifacts/test-runner.com " args)
        handle (io.popen cmd)
        output (handle:read "*a")
        success (handle:close)]
    {:output output :success success}))

(fn test-match-filter-includes-matching-tests []
  "Test that --match flag includes only matching tests"
  (let [result (run-with-filters "--match filter test/filter_test.fnl")]
    (testing "match filter output"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "Running tests with filters: --match=filter")
         (asserts.includes result.output "should-run-test-combined-filters")
         (asserts.includes result.output "should-run-test-no-filters")
         ;; Should NOT include tests without "filter" in name
         (asserts.falsy (result.output:match "should%-run%-test%-case%-insensitive"))))))

(fn test-no-match-filter-excludes-matching-tests []
  "Test that --no-match flag excludes matching tests"
  (let [result (run-with-filters "--no-match filter test/filter_test.fnl")]
    (testing "no-match filter output"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "Running tests with filters: --no-match=filter")
         ;; Should include tests without "filter" in name
         (asserts.includes result.output "should-run-test-case-insensitive")
         ;; Should NOT include tests with "filter" in name
         (asserts.falsy (result.output:match "should-run-test-combined-filters"))))))

(fn test-combined-filters []
  "Test that --match and --no-match work together"
  (let [result (run-with-filters "--match include --no-match multiple test/filter_test.fnl")]
    (testing "combined filters output"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "--match=include")
         (asserts.includes result.output "--no-match=multiple")
         ;; Should only include "include" tests without "multiple"
         (asserts.includes result.output "should-run-test-include-only")
         ;; Should NOT include tests with "multiple"
         (asserts.falsy (result.output:match "should-run-test-multiple-includes"))))))

(fn test-case-insensitive-matching []
  "Test that filters are case-insensitive"
  (let [result (run-with-filters "--match CASE test/filter_test.fnl")]
    (testing "case-insensitive matching"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "--match=CASE")
         (asserts.includes result.output "should-run-test-case-insensitive")))))

(fn test-no-matching-tests []
  "Test that no matches produces appropriate output"
  (let [result (run-with-filters "--match nonexistent test/filter_test.fnl")]
    (testing "no matches output"
      #(do
         (asserts.ok result.success "Command should succeed with exit 0")
         (asserts.includes result.output "No tests matched the provided filters")))))

(fn test-empty-filter-validation []
  "Test that empty filters are rejected"
  (let [result (run-with-filters "--match \"\" test/filter_test.fnl 2>&1")]
    (testing "empty filter validation"
      #(do
         (asserts.falsy result.success "Command should fail")
         (asserts.includes result.output "filter cannot be empty")))))

(fn test-multiple-match-flags []
  "Test that multiple --match flags work (OR logic)"
  (let [result (run-with-filters "-m include -m exclude test/filter_test.fnl")]
    (testing "multiple match flags"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "--match=include")
         (asserts.includes result.output "--match=exclude")
         ;; Should include tests matching either filter
         (asserts.includes result.output "should-run-test-include-only")
         (asserts.includes result.output "should-run-test-exclude-only")))))

(fn test-short-flag-aliases []
  "Test that short flags -m and -M work"
  (let [result (run-with-filters "-m case test/filter_test.fnl")]
    (testing "short flag aliases"
      #(do
         (asserts.ok result.success "Command should succeed")
         (asserts.includes result.output "--match=case")
         (asserts.includes result.output "should-run-test-case-insensitive")))))

{: test-match-filter-includes-matching-tests
 : test-no-match-filter-excludes-matching-tests
 : test-combined-filters
 : test-case-insensitive-matching
 : test-no-matching-tests
 : test-empty-filter-validation
 : test-multiple-match-flags
 : test-short-flag-aliases}
