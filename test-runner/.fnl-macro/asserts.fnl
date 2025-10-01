;; fennel-ls: macro-file

(local asserts {})

(fn asserts.ok [v ?message]
  `(let [test# (require :test)
         passed?# ,v
         msg# (or ,?message "assertion failed")]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error msg# 2))))

(fn asserts.= [a b]
  `(let [test# (require :test)
         passed?# (= ,a ,b)]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. (tostring ,a) " is not equal to " (tostring ,b)) 2))))

(fn asserts.not= [a b]
  `(let [test# (require :test)
         passed?# (not (= ,a ,b))]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. (tostring ,a) " is equal to " (tostring ,b)) 2))))

(fn asserts.nil? [v]
  `(let [test# (require :test)
         passed?# (= nil ,v)]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. (tostring ,v) " is not nil") 2))))

(fn asserts.falsy [v ?message]
  `(let [test# (require :test)
         passed?# (not ,v)]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (or ,?message (.. (tostring ,v) " is not falsy")) 2))))

(fn asserts.deep= [a b]
  `(let [test# (require :test)
         fnl# (require :fennel)
         passed?# ((. test# :deep-equal) ,a ,b)]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. (fnl#.view ,a)
                                     "\n  is not deeply equal to\n  "
                                     (fnl#.view ,b)) 2))))

(fn asserts.match [text pattern]
  `(let [test# (require :test)
         passed?# (string.find ,text ,pattern)]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. "Pattern '" ,pattern "' not found in text: " (tostring ,text)) 2))))

(fn asserts.includes [text substring]
  `(let [test# (require :test)
         passed?# (not= nil (string.find ,text ,substring 1 true))]
     (test#.handle-assertion passed?#)
     (when (not passed?#) (error (.. "Substring '" ,substring "' not found in text: " (tostring ,text)) 2))))

(fn asserts.throws [test-fn ?pattern]
  `(let [test# (require :test)
         (ok?# err#) (pcall ,test-fn)]
     (if ok?#
         (do
           (test#.handle-assertion false)
           (error "Expected function to throw an error, but it succeeded" 2))
         (if ,?pattern
             (let [pattern-match?# (string.find err# ,?pattern)]
               (test#.handle-assertion pattern-match?#)
               (when (not pattern-match?#)
                 (error (.. "Error message '" err# "' does not match pattern '" ,?pattern "'") 2)))
             (do
               (test#.handle-assertion true)
               true)))))

asserts
