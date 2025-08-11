# Fennel Test Runner (Redbean-based)

A self-contained **Fennel** test runner packaged into a single **Redbean** `.com` executable.  
It discovers `*_test.fnl` files, runs them (in parallel per file), and prints a compact summary.

## Features

* Test discovery across the repo (`*_test.fnl`)

  * **Structure:** each test file must return a table whose keys start with `test-` and whose values are functions.
    Example:

    ```fennel
    (local assert (require :assert))

    {:test-addition
      (fn [] (assert.= (+ 1 1) 2))
     :test-truthy #(assert.ok "non-empty string")}
    ```
  * See [assert_test.fnl](test/assert_test.fnl) for a full example.
  * These functions are executed individually, with results grouped and summarized.
* Parallel execution per test file (process-fork based)
* Grouped assertions with pass/fail counts

---

## Requirements (for building)
- `make`, `curl`, `zip`
- Linux/macOS shell environment

> The resulting binary runs standalone; no Fennel installation is required on the target machine.

## Quick Start

```sh
# Build the runner (downloads redbean + fennel.lua, bundles tests)
make

# Run the test suite (builds first if needed)
make test

# Or run the binary directly
./artifacts/test-runner.com

# Show usage help
./artifacts/test-runner.com --help
```

For detailed usage examples, see [USAGE.md](USAGE.md).

## Make Targets

- `make` or `make artifacts/test-runner.com` – build the binary
- `make test` – build (if needed) and run tests
- `make clean` – remove build outputs
- `make lint` – lint `*.fnl` with `fennel-ls` (must be installed)

For complete usage documentation including test structure, assertions, and mocking, see [USAGE.md](USAGE.md).
