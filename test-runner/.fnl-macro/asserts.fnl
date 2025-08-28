;; fennel-ls: macro-file

(local asserts {})

(fn asserts.ok [v ?message]
  `(let [assert-mod# (require :assert)
         passed?# ,v
         msg# (or ,?message "assertion failed")]
     (assert-mod#.handle-assertion passed?# msg#)
     (assert passed?# msg#)))

(fn asserts.= [a b]
  `(let [assert-mod# (require :assert)
         passed?# (= ,a ,b)
         error-msg# (.. (tostring ,a) " is not equal to " (tostring ,b))]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.not= [a b]
  `(let [assert-mod# (require :assert)
         passed?# (not (= ,a ,b))
         error-msg# (.. (tostring ,a) " is equal to " (tostring ,b))]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.nil? [v]
  `(let [assert-mod# (require :assert)
         passed?# (= nil ,v)
         error-msg# (.. (tostring ,v) " is not nil")]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.falsy [v ?message]
  `(let [assert-mod# (require :assert)
         passed?# (not ,v)
         error-msg# (or ,?message (.. (tostring ,v) " is not falsy"))]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.deep= [a b]
  `(let [assert-mod# (require :assert)
         fnl# (require :fennel)
         passed?# ((. assert-mod# :deep-equal) ,a ,b)
         error-msg# (.. "\n  " (fnl#.view ,a)
                       "\n  is not deeply equal to\n  "
                       (fnl#.view ,b))]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.match [pattern text]
  `(let [assert-mod# (require :assert)
         passed?# (string.find ,text ,pattern)
         error-msg# (.. "Pattern '" ,pattern "' not found in text: " (tostring ,text))]
     (assert-mod#.handle-assertion passed?# error-msg#)
     (assert passed?# error-msg#)))

(fn asserts.throws [test-fn ?pattern]
  `(let [assert-mod# (require :assert)
         (ok?# err#) (pcall ,test-fn)]
     (if ok?#
         (do
           (assert-mod#.handle-assertion false "Expected function to throw an error, but it succeeded")
           (assert false "Expected function to throw an error, but it succeeded"))
         (if ,?pattern
             (let [pattern-match?# (string.find err# ,?pattern)
                   error-msg# (.. "Error message '" err# "' does not match pattern '" ,?pattern "'")]
               (assert-mod#.handle-assertion pattern-match?# error-msg#)
               (assert pattern-match?# error-msg#))
             (do
               (assert-mod#.handle-assertion true)
               true)))))

asserts
