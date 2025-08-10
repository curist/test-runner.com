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
```

### Filter which tests to run
You can pass paths (files or directories). Examples:

```sh
# Run only one file
./artifacts/test-runner.com test/assert_test.fnl

# Run everything under a directory
./artifacts/test-runner.com test/

# Using make and forwarding args
make test ARGS="test/ test/assert_test.fnl"
```

## Make Targets

- `make` or `make artifacts/test-runner.com` – build the binary
- `make test` – build (if needed) and run tests
- `make clean` – remove build outputs
- `make lint` – lint `*.fnl` with `fennel-ls` (must be installed)

## Assertions

| Function                | Description |
|-------------------------|-------------|
| `(assert.ok v ?msg)`   | Passes if `v` is truthy. Optional `?msg` overrides default error text. |
| `(assert.falsy v ?msg)`| Passes if `v` is `nil` or `false`. |
| `(assert.= a b)`        | Passes if `a == b`. |
| `(assert.not= a b)`     | Passes if `a != b`. |
| `(assert.nil? v)`       | Passes if `v` is `nil`. |
| `(assert.deep= a b)`    | Deep table equality check; works recursively. |
