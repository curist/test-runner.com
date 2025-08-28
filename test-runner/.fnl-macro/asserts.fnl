;; fennel-ls: macro-file

(local asserts {})

(fn asserts.ok [v ?message]
  `(let [test# (require :test)
         passed?# ,v
         msg# (or ,?message "assertion failed")]
     (test#.handle-assertion passed?#)
     (assert passed?# msg#)))

(fn asserts.= [a b]
  `(let [test# (require :test)
         passed?# (= ,a ,b)]
     (test#.handle-assertion passed?#)
     (assert passed?# (.. (tostring ,a) " is not equal to " (tostring ,b)))))

(fn asserts.not= [a b]
  `(let [test# (require :test)
         passed?# (not (= ,a ,b))]
     (test#.handle-assertion passed?#)
     (assert passed?# (.. (tostring ,a) " is equal to " (tostring ,b)))))

(fn asserts.nil? [v]
  `(let [test# (require :test)
         passed?# (= nil ,v)
         error-msg# (.. (tostring ,v) " is not nil")]
     (test#.handle-assertion passed?#)
     (assert passed?# error-msg#)))

(fn asserts.falsy [v ?message]
  `(let [test# (require :test)
         passed?# (not ,v)]
     (test#.handle-assertion passed?#)
     (assert passed?# (or ,?message (.. (tostring ,v) " is not falsy")))))

(fn asserts.deep= [a b]
  `(let [test# (require :test)
         fnl# (require :fennel)
         passed?# ((. test# :deep-equal) ,a ,b)]
     (test#.handle-assertion passed?#)
     (assert passed?# (.. "\n  " (fnl#.view ,a)
                          "\n  is not deeply equal to\n  "
                          (fnl#.view ,b)))))

(fn asserts.match [pattern text]
  `(let [test# (require :test)
         passed?# (string.find ,text ,pattern)]
     (test#.handle-assertion passed?#)
     (assert passed?# (.. "Pattern '" ,pattern "' not found in text: " (tostring ,text)))))

(fn asserts.throws [test-fn ?pattern]
  `(let [test# (require :test)
         (ok?# err#) (pcall ,test-fn)]
     (if ok?#
         (do
           (test#.handle-assertion false)
           (assert false "Expected function to throw an error, but it succeeded"))
         (if ,?pattern
             (let [pattern-match?# (string.find err# ,?pattern)
                   error-msg# (.. "Error message '" err# "' does not match pattern '" ,?pattern "'")]
               (test#.handle-assertion pattern-match?#)
               (assert pattern-match?# error-msg#))
             (do
               (test#.handle-assertion true)
               true)))))

asserts
