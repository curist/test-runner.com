(local rb (require :__testrunner__.redbean))
(local test-runner (require :__testrunner__.test-runner))
(local fennel (require :fennel))

(fn show-help []
  "Display help information from embedded USAGE.md"
  (let [usage-content (rb.slurp "/zip/USAGE.md")]
    (if usage-content
        (print usage-content)
        (print "Help documentation not available")))
  (os.exit 0))

(fn show-version []
  "Display version and build information"
  (let [version (rb.slurp "/zip/VERSION.txt")
        redbean-version (or (rb.slurp "/zip/redbean.version.txt") "unknown")]
    (if version
        (print (.. "test-runner.com " (version:gsub "\n" "")))
        (print "test-runner.com (dev)"))
    (print (.. "redbean version: " (redbean-version:gsub "\n" "")))
    (print (.. "fennel version: " fennel.version)))
  (os.exit 0))

(fn parse-flags [args]
  "Parse command line flags and return options table with paths, matches, and excludes"
  (let [options {:paths [] :matches [] :excludes []}]
    (var parsing-flags true)
    (var i 1)
    (while (<= i (length args))
      (let [arg (. args i)]
        (if (not parsing-flags)
            ;; After --, treat everything as positional argument
            (table.insert options.paths arg)
            (= arg "--")
            ;; Stop parsing flags after --
            (set parsing-flags false)
            (or (= arg "--help") (= arg "-h"))
            (show-help)
            (or (= arg "--version") (= arg "-v"))
            (show-version)
            ;; Handle --match / -m flag
            (or (= arg "--match") (= arg "-m"))
            (do
              (set i (+ i 1))
              (let [value (. args i)]
                (if (not value)
                    (do
                      (print (.. "test-runner.com: option '" arg "' requires a value"))
                      (print "Try 'test-runner.com --help' for more information.")
                      (os.exit 1))
                    (= value "")
                    (do
                      (print "test-runner.com: filter cannot be empty")
                      (print "Try 'test-runner.com --help' for more information.")
                      (os.exit 1))
                    (table.insert options.matches value))))
            ;; Handle --no-match / -M flag
            (or (= arg "--no-match") (= arg "-M"))
            (do
              (set i (+ i 1))
              (let [value (. args i)]
                (if (not value)
                    (do
                      (print (.. "test-runner.com: option '" arg "' requires a value"))
                      (print "Try 'test-runner.com --help' for more information.")
                      (os.exit 1))
                    (= value "")
                    (do
                      (print "test-runner.com: filter cannot be empty")
                      (print "Try 'test-runner.com --help' for more information.")
                      (os.exit 1))
                    (table.insert options.excludes value))))
            ;; Check for unknown flags
            (arg:match "^%-")
            (do
              (print (.. "test-runner.com: unknown option '" arg "'"))
              (print "Try 'test-runner.com --help' for more information.")
              (os.exit 1))
            ;; Not a flag, keep it
            (table.insert options.paths arg)))
      (set i (+ i 1)))
    options))

;; Main execution with enhanced error handling
(let [options (parse-flags _G.arg)
      tests (test-runner.collect-test-files options.paths)]
  (test-runner.run-tests tests options))
