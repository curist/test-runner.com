(local rb (require :redbean))
(local test-runner (require :test-runner))
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
  "Parse command line flags and return filtered arguments"
  (let [filtered-args []]
    (each [_ arg (ipairs args)]
      (if (or (= arg "--help") (= arg "-h"))
          (show-help)
          (or (= arg "--version") (= arg "-v"))
          (show-version)
          ;; Check for unknown flags
          (arg:match "^%-")
          (do
            (print (.. "test-runner.com: unknown option '" arg "'"))
            (print "Try 'test-runner.com --help' for more information.")
            (os.exit 1))
          ;; Not a flag, keep it
          (table.insert filtered-args arg)))
    filtered-args))

;; Main execution with enhanced error handling
(-> _G.arg
    parse-flags
    test-runner.collect-test-files
    test-runner.run-tests)
