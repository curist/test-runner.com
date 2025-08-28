;; fennel-ls: macro-file

(local asserts {})

(fn asserts.ok [v ?message]
  `(let [test# (require :test)
         passed?# ,v
         msg# (or ,?message "assertion failed")]
     (test#.handle-assertion passed?# msg#)
     (assert passed?# msg#)))

(fn asserts.= [a b]
  `(let [test# (require :test)
         passed?# (= ,a ,b)
         error-msg# (.. (tostring ,a) " is not equal to " (tostring ,b))]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.not= [a b]
  `(let [test# (require :test)
         passed?# (not (= ,a ,b))
         error-msg# (.. (tostring ,a) " is equal to " (tostring ,b))]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.nil? [v]
  `(let [test# (require :test)
         passed?# (= nil ,v)
         error-msg# (.. (tostring ,v) " is not nil")]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.falsy [v ?message]
  `(let [test# (require :test)
         passed?# (not ,v)
         error-msg# (or ,?message (.. (tostring ,v) " is not falsy"))]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.deep= [a b]
  `(let [test# (require :test)
         fnl# (require :fennel)
         passed?# ((. test# :deep-equal) ,a ,b)
         error-msg# (.. "\n  " (fnl#.view ,a)
                       "\n  is not deeply equal to\n  "
                       (fnl#.view ,b))]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.match [pattern text]
  `(let [test# (require :test)
         passed?# (string.find ,text ,pattern)
         error-msg# (.. "Pattern '" ,pattern "' not found in text: " (tostring ,text))]
     (test#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.throws [test-fn ?pattern]
  `(let [test# (require :test)
         (ok?# err#) (pcall ,test-fn)]
     (if ok?#
         (do
           (test#.handle-assertion false "Expected function to throw an error, but it succeeded")
           (assert false "Expected function to throw an error, but it succeeded"))
         (if ,?pattern
             (let [pattern-match?# (string.find err# ,?pattern)
                   error-msg# (.. "Error message '" err# "' does not match pattern '" ,?pattern "'")]
               (test#.handle-assertion pattern-match?# error-msg#)
               (assert pattern-match?# error-msg#))
             (do
               (test#.handle-assertion true)
               true)))))

asserts
