# test-runner.com

A self-contained Fennel test runner that discovers `*_test.fnl` files, runs them in parallel, and prints a compact summary.

## Features

* **Test discovery** - Finds `*_test.fnl` files across your repository
* **Parallel execution** - Runs tests in parallel per file for speed  
* **Self-contained** - Single binary, no dependencies required
* **Rich assertions** - Built-in assertion library with helpful error messages
* **Mocking support** - Mock modules and global variables for testing

## Quick Start

Download the latest release:

```sh
# Download and make executable
curl -L https://github.com/curist/test-runner.com/releases/latest/download/test-runner.com -o test-runner.com
chmod +x test-runner.com

# Run all tests
./test-runner.com

# Show help
./test-runner.com --help
```

Or using wget:
```sh
wget https://github.com/curist/test-runner.com/releases/latest/download/test-runner.com
chmod +x test-runner.com
```

## Test Structure

Test files must be named `*_test.fnl` and return a table with `test-*` functions:

```fennel
(local assert (require :assert))

{:test-addition
 (fn [] (assert.= (+ 1 1) 2))
 :test-truthy 
 (fn [] (assert.ok "non-empty string"))}
```

See [assert_test.fnl](test/assert_test.fnl) for a complete example.

For detailed usage documentation including assertions and mocking, see [USAGE.md](USAGE.md?plain=1).

## Development

To build from source:
```sh
make        # Build the binary
make test   # Run tests (builds first if needed)
make clean  # Remove build outputs
```

Requirements: `make`, `curl`, `zip`, Linux/macOS environment

## AI / LLM Usage

This project was developed with assistance from large language models (LLMs).

LLMs were used to help with:

* Drafting and iterating on code implementations
* Generating boilerplate and repetitive structures  
* Refining documentation and comments

## License

MIT License - see [LICENSE](LICENSE) file for details.
