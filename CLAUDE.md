# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Development Commands

```bash
# Build the test runner binary (downloads dependencies and creates artifacts/test-runner.com)
make

# Run all tests (builds first if needed)
make test

# Run tests with specific files or directories
make test ARGS="test/assert_test.fnl"
make test ARGS="test/"

# Show help information
./artifacts/test-runner.com --help

# Show version information
./artifacts/test-runner.com --version

# Clean build artifacts
make clean

# Lint Fennel code (requires fennel-ls to be installed)
make lint
```

## Architecture Overview

This is a self-contained **Fennel** test runner packaged into a single **Redbean** executable. The architecture consists of:

### Core Components

- **Redbean**: Provides the runtime environment (embedded Lua + HTTP server)
- **Fennel**: Lisp-like language that compiles to Lua
- **Test Discovery**: Finds `*_test.fnl` files across the repository
- **Parallel Execution**: Runs tests in parallel per file using process forking

### Build Process

The build system downloads external dependencies and bundles everything into a single executable:

1. Downloads latest Redbean binary from redbean.dev
2. Downloads Fennel compiler (v1.5.3)
3. Bundles test-runner source code and license
4. Creates single `artifacts/test-runner.com` executable

### Test Structure

Test files must follow this pattern:
- Named `*_test.fnl`
- Return a table with keys starting with `test-` 
- Values are functions containing assertions

```fennel
{:test-example-name
 (fn [] (assert.= (+ 1 1) 2))
 :test-another-test
 (fn [] (assert.ok "truthy value"))}
```

### Assertion Library

Available assertion functions:
- `(assert.ok v ?msg)` - truthy check
- `(assert.falsy v ?msg)` - falsy check  
- `(assert.= a b)` - equality
- `(assert.not= a b)` - inequality
- `(assert.nil? v)` - nil check
- `(assert.deep= a b)` - deep table equality
- `(testing "description" test-fn)` - grouped assertions

### Mocking System

The test runner includes a mocking system via `mocks.fnl` for dependency injection during tests. Use `with-open` blocks to ensure mocks are properly cleaned up:

```fennel
(local mocks (require :mocks))

;; Basic mocking pattern
(fn with-mocked-dependencies [f]
  (with-open [mock1 (mocks.mock :module1 mock-impl1)
              mock2 (mocks.mock :module2 mock-impl2)]
    (local module-under-test (require :module-under-test))
    (f module-under-test)))

(fn test-something []
  (with-mocked-dependencies
    (fn [module]
      (testing "some behavior"
        #(assert.= expected (module.function))))))
```

**Key principles:**
- Mock modules **before** requiring the module under test
- Use `with-open` to automatically clean up mocks when the scope exits
- Create mock implementations that match the expected interface
- Combine with `testing` blocks for organized test structure

**Complex mocking example:**
```fennel
;; Create mock state objects to track interactions
(local mock-redbean-state {:method "GET" :path "/" :headers {}})
(local mock-redbean 
  {:get-method (fn [] mock-redbean-state.method)
   :get-path (fn [] mock-redbean-state.path)
   :set-header (fn [name value] (tset mock-redbean-state.headers name value))})

(fn with-mocked-app [f]
  (with-open [rb-mock (mocks.mock :redbean mock-redbean)
              router-mock (mocks.mock :router mock-router)]
    (local app (require :app.init-app))
    (f app)))
```

## File Structure

- `test-runner/init.lua` - Entry point that loads Fennel and test runner
- `test/` - Contains test files (`*_test.fnl`)
- `artifacts/` - Build outputs (gitignored)
- `Makefile` - Build configuration and commands
- `.github/workflows/release.yml` - CI/CD for releasing binaries

## Development Notes

- The project uses Fennel 1.5.3 specifically
- Tests run in parallel per file for performance
- The final binary is completely standalone - no Fennel installation required on target machines
- Release process is automated via GitHub Actions on version tags