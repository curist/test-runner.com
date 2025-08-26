(local assert (require :assert))

(fn run-cli [args]
  "Run the test-runner CLI with given args and return {output, success, exit-code}"
  (let [cmd (.. "./artifacts/test-runner.com " args)
        proc (io.popen cmd "r")
        output (proc:read "*a")
        success (proc:close)]
    {:output output :success success}))

{:test-help-flag
 (fn []
   "Test that --help flag works without error"
   (let [result (run-cli "--help")]
     (assert.ok result.success "--help should exit successfully")))

 :test-version-flag
 (fn []
   "Test that --version flag works without error"
   (let [result (run-cli "--version")]
     (assert.ok result.success "--version should exit successfully")))

 :test-invalid-flag-handling
 (fn []
   "Test that invalid flags cause the program to exit with failure"
   (let [result (run-cli "--invalid-flag")]
     (assert.falsy result.success "Invalid flags should cause failure exit code")))

 :test-invalid-flag-error-message
 (fn []
   "Test that invalid flags show proper error message"
   (let [result (run-cli "--invalid")]
     (assert.falsy result.success "Invalid flag should fail")
     (assert.match "unknown option" result.output)))

 :test-successful-test-execution
 (fn []
   "Test that valid test files execute successfully"
   (let [result (run-cli "test/assert_test.fnl")]
     (assert.ok result.success "assert_test.fnl should pass and exit successfully")))

 :test-failing-test-exit-code
 (fn []
   "Test that failing tests cause exit code 1"
   ;; Create temporary failing test file
   (let [temp-file "test_fail_temp.fnl"
         temp-content "{:test-fail (fn [] (assert.= 1 2))}"]
     ;; Write temporary test file
     (with-open [f (io.open temp-file "w")]
       (f:write temp-content))

     ;; Run test and check it fails
     (let [result (run-cli temp-file)]
       ;; Clean up temp file
       (os.remove temp-file)

       ;; Assert the test failed as expected
       (assert.falsy result.success "Failing test should exit with non-zero code"))))}
