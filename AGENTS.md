# Repository Guidelines

## Project Structure & Module Organization
The Fennel sources for the executable live in `test-runner/.fnl`, with the entry point at `__testrunner__/main.fnl`. `test-runner/.lua` hosts vendored runtime dependencies produced during builds; avoid editing it by hand. Packaged assets and the redbean bootstrap files ship under `redbean-fennel/`. Repository-level tests reside in `test/` and must export tables of `test-*` functions, matching the runner’s discovery logic. Build outputs are created inside `artifacts/`; the folder is disposable and should not be committed.

## Build, Test, and Development Commands
Run `make` (default) or `make test` to build `artifacts/test-runner.com` and execute the suite; pass extra args with `make test ARGS='--help'`. Use `make lint` to run `fennel-ls` against every `.fnl` file, and `make clean` to remove `artifacts/`. After a build you can invoke the tool directly via `./artifacts/test-runner.com path/to/tests` to scope runs.

## Coding Style & Naming Conventions
Write Fennel with two-space indentation and hang closing parens on their own line when forms span clauses. Prefer keyword tables (`{:key val}`) and dotted module namespaces (`__testrunner__.future`). Provide a short string literal doc immediately inside functions that surface user-facing help, mirroring the pattern in `main.fnl`. Tests should expose functions named `test-*`, while helpers use dash-delimited names (`test.deep-equal`).

## Testing Guidelines
Target the bundled runner: `make test` or `./artifacts/test-runner.com` from the repo root. Keep files in `test/` named `*_test.fnl`; the runner loads them automatically and executes groups in parallel, so avoid shared mutable globals. When reproducing regressions add focused assertions and consider the `test.testing` helper for grouping. There is no enforced coverage threshold, but add regression tests for every bug.

## Commit & Pull Request Guidelines
Commit history favors short, descriptive subject lines (`namespace test-runner internal modules`). Use the imperative mood, stick to lowercase unless naming proper nouns, and keep subjects under 60 characters. Squash locally to keep related changes together. Pull requests should outline the motivation, list functional changes, note any new commands or flags, and include before/after output snippets when adjusting runner reporting. Link issues when available and confirm tests or lint ran.
