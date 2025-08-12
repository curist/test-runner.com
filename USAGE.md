SYNOPSIS

  test-runner.com [FLAG] [PATH...]

DESCRIPTION

  test-runner - self-contained Fennel test runner

OVERVIEW

  test-runner makes it possible to run Fennel tests offline as a single
  executable. It discovers `*_test.fnl` files and runs them in parallel
  per file for fast execution.

FLAGS

  -h or --help     display this text
  -v or --version  show version and build information

When not given a path, discovers and runs all `*_test.fnl` files in the current directory.
When given paths, runs tests only for the specified files or directories.

Examples:

  test-runner.com                           # Run all tests
  test-runner.com test/my_test.fnl          # Run specific test file  
  test-runner.com test/                     # Run all tests in directory
  test-runner.com test/unit/ test/app_test.fnl  # Run multiple paths

Test files must be named `*_test.fnl` and export a table with `test-*` functions:

  (local assert (require :assert))

  {:test-addition
   (fn [] (assert.= (+ 1 1) 2))

   :test-truthy 
   (fn [] (assert.ok "non-empty string"))}

Assertions:

  (assert.ok v ?msg)           Passes if v is truthy
  (assert.falsy v ?msg)        Passes if v is nil or false
  (assert.= a b)               Passes if a == b
  (assert.not= a b)            Passes if a != b
  (assert.nil? v)              Passes if v is nil
  (assert.deep= a b)           Deep table equality check
  (assert.match pattern text)  Passes if text contains pattern (Lua patterns)
  (assert.throws fn ?pattern)  Passes if fn throws an error, optionally matching pattern

Use `testing` for organized test groups:

  (local {: testing} (require :assert))

  {:test-math-operations
   (fn []
     (testing "basic arithmetic"
       #(do (assert.= (+ 2 2) 4)
            (assert.= (* 3 3) 9))))}

Use the mocking system for dependency injection:

  (local mocks (require :mocks))

  ;; Mock modules in package.loaded
  (fn test-with-module-mocks []
    (with-open [mock1 (mocks.mock :module1 mock-impl)]
      (local module (require :module-under-test))
      (assert.= expected (module.function))))

  ;; Mock global variables in _G
  (fn test-with-global-mocks []
    (with-open [global-mock (mocks.mock-global :some-global mock-value)]
      (assert.= mock-value some-global)))
