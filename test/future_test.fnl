(local assert (require :assert))
(local future (require :future))
(local rb (require :redbean))
(local {: testing} assert)

(fn test-basic-future-operations []
  (testing "basic async execution and error handling"
    #(do
       ;; Test basic future success
       (let [task #"hello from the other side"
             f (future.async task)]
         (assert.= "hello from the other side" (f:await)))

       ;; Test error propagation
       (let [task #(error "this is a test error")
             f (future.async task)
             (ok err) (pcall #(f:await))]
         (assert.ok (not ok))
         (assert.ok (string.find err "this is a test error")))

       ;; Test table error handling  
       (let [error-tbl {:code 123 :message "custom error"}
             task #(error error-tbl)
             f (future.async task)
             (ok err) (pcall #(f:await))]
         (assert.ok (not ok))
         ;; Error should contain the table information
         (assert.ok (string.match err "table") 
                    "Should handle table errors"))))

  (testing "concurrency and caching behavior"
    #(do
       ;; Test concurrent execution
       (let [(sec1 nsec1) (rb.unix.clock_gettime)
             task1 #(do (rb.unix.nanosleep 0 100000000) "one")
             task2 #(do (rb.unix.nanosleep 0 100000000) "two")
             f1 (future.async task1)
             f2 (future.async task2)
             res1 (f1:await)
             res2 (f2:await)
             (sec2 nsec2) (rb.unix.clock_gettime)
             t1 (+ sec1 (/ nsec1 1e9))
             t2 (+ sec2 (/ nsec2 1e9))
             duration (- t2 t1)]
         (assert.= "one" res1)
         (assert.= "two" res2)
         ;; Should be ~0.1s (parallel), not ~0.2s (sequential)
         (assert.ok (< duration 0.15) (.. "duration was " duration)))

       ;; Test result caching
       (let [f (future.async #"cached value")]
         (assert.= "cached value" (f:await))
         (assert.= "cached value" (f:await) "second call should return cached value"))))

  (testing "timeout and cancellation"
    #(do
       ;; Test timeout functionality
       (let [long-task #(do (rb.unix.nanosleep 0 200000000) "done")
             f (future.async long-task)
             (ok err) (pcall #(f:await 100))]
         (assert.ok (not ok) "pcall should have failed")
         (assert.ok (string.find err "timeout") (.. "expected timeout error, got: " (tostring err))))

       ;; Test cancellation
       (let [long-task #(do (rb.unix.sleep 5) "done")
             f (future.async long-task)]
         (rb.unix.nanosleep 0 10000000)  ; Give process a moment to start
         (f:cancel)
         (let [(ok err) (pcall #(f:await))]
           (assert.ok (not ok) "awaiting a cancelled future should fail")
           (assert.ok (string.find (tostring err) "cancelled") "error message should mention cancellation"))))))

(fn test-future-combinators []
  (testing "future.all operations"
    #(do
       ;; Test basic future.all functionality  
       (let [f1 (future.async #(+ 1 2))
             f2 (future.async #(* 3 4))
             all-f (future.all [f1 f2])
             results (all-f:await)]
         (assert.deep= [3 12] results))

       ;; Test future.all result caching
       (let [f1 (future.async #(+ 1 2))
             f2 (future.async #(* 3 4))
             all-f (future.all [f1 f2])
             results1 (all-f:await)]
         (assert.deep= [3 12] results1)
         (let [results2 (all-f:await)]
           (assert.deep= [3 12] results2 "second call should return cached value")))

       ;; Test future.all timeout
       (let [f1 (future.sleep 50)   ; Fast task
             f2 (future.sleep 200)  ; Slow task that causes timeout
             all-f (future.all [f1 f2])
             (ok err) (pcall #(all-f:await 100))]
         (assert.ok (not ok))
         (assert.ok (err:find "timeout")))

       ;; Test future.all cancellation
       (let [f1 (future.sleep 200)  ; Long-running task
             f2 (future.sleep 300)  ; Even longer-running task  
             all-f (future.all [f1 f2])]
         (rb.unix.nanosleep 0 10000000)  ; Give tasks a moment to start
         (all-f:cancel)
         (let [(ok err) (pcall #(all-f:await))]
           (assert.ok (not ok))
           (assert.ok (err:find "cancelled"))))))

  (testing "future.race operations"
    #(do
       ;; Test race with fastest future winning
       (let [f-fast (future.sleep 50)
             f-slow (future.sleep 200)
             race (future.race [f-fast f-slow])
             winner-result (race:await)]
         (assert.= 0 winner-result))

       ;; Test race with error from fastest future
       (let [f-fast-error (future.async #(error "fast error"))
             f-slow-ok (future.sleep 200)
             race (future.race [f-fast-error f-slow-ok])
             (ok err) (pcall #(race:await))]
         (assert.ok (not ok))
         (assert.ok (err:find "fast error")))

       ;; Test race cancels losing futures
       (let [f-fast (future.sleep 50)
             f-slow (future.sleep 200)
             race (future.race [f-fast f-slow])]
         (race:await)
         ;; After the race, the slow future should have been cancelled
         (let [(ok err) (pcall #(f-slow:await))]
           (assert.ok (not ok))
           (assert.ok (string.find (tostring err) "cancelled"))))

       ;; Test race timeout
       (let [f1 (future.sleep 200)
             f2 (future.sleep 300)
             race (future.race [f1 f2])
             (ok err) (pcall #(race:await 100))]
         (assert.ok (not ok))
         (assert.ok (err:find "timeout")))

       ;; Test race with empty list error
       (let [(ok err) (pcall #(future.race []))]
         (assert.ok (not ok))
         (assert.ok (err:find "race requires at least one future")))))

  (testing "utility functions and helpers"  
    #(do
       ;; Test pre-resolved future
       (let [f (future.resolve "pre-resolved")]
         (assert.= "pre-resolved" (f:await)))

       ;; Test pre-rejected future
       (let [f (future.reject "pre-rejected error")
             (ok err) (pcall #(f:await))]
         (assert.ok (not ok))
         (assert.ok (err:find "pre-rejected error" nil true)))

       ;; Test sleep helper timing
       (let [(sec1 nsec1) (rb.unix.clock_gettime)
             f (future.sleep 100)  ; 100ms
             _ (f:await)
             (sec2 nsec2) (rb.unix.clock_gettime)
             t1 (+ sec1 (/ nsec1 1e9))
             t2 (+ sec2 (/ nsec2 1e9))
             duration (- t2 t1)]
         (assert.ok (and (> duration 0.1) (< duration 0.15))
           (.. "duration was " duration)))

       ;; Test nanosleep helper timing
       (let [(sec1 nsec1) (rb.unix.clock_gettime)
             f (future.nanosleep 0 100000000)  ; 0.1s
             _ (f:await)
             (sec2 nsec2) (rb.unix.clock_gettime)
             t1 (+ sec1 (/ nsec1 1e9))
             t2 (+ sec2 (/ nsec2 1e9))
             duration (- t2 t1)]
         (assert.ok (and (> duration 0.1) (< duration 0.15))
           (.. "duration was " duration)))

       ;; Test is-future? helper via Future.resolve
       (let [f (future.async #"test")
             all-f (future.all [f])
             race-f (future.race [f])
             regular-table {:foo "bar"}]
         ;; Check via Future.resolve which uses is-future? internally
         (assert.= f (future.resolve f) "Future should be returned as-is")
         (assert.= all-f (future.resolve all-f) "AllFuture should be returned as-is")
         (assert.= race-f (future.resolve race-f) "RaceFuture should be returned as-is")
         ;; Regular table should be wrapped in a resolved future
         (let [wrapped (future.resolve regular-table)]
           (assert.not= regular-table wrapped "Regular table should be wrapped")
           (assert.deep= regular-table (wrapped:await) "Wrapped table should contain original value"))))))

(fn test-large-payload-handling []
  (testing "large payload write-until-complete"
    #(do
       ;; Test with payload larger than PIPE_BUF (4096 bytes)
       (let [large-string (string.rep "abcdefghij" 500)  ; 5000 bytes
             f (future.async (fn [] large-string))
             result (f:await)]
         (assert.= 5000 (length result))
         (assert.= large-string result))
       
       ;; Test with large table payload
       (let [large-table (fcollect [i 1 1000] {:id i :data (string.rep "x" 10)})
             f (future.async (fn [] large-table))
             result (f:await)]
         (assert.= 1000 (length result))
         (assert.= 1 (. result 1 :id))
         (assert.= 1000 (. result 1000 :id))
         (assert.= "xxxxxxxxxx" (. result 1 :data)))
       
       ;; Test partial write scenario with mixed content
       (let [complex-data {:large-text (string.rep "Lorem ipsum dolor sit amet, " 200)  ; ~5600 bytes
                          :numbers (fcollect [i 1 100] i)
                          :nested {:deep {:data (string.rep "nested" 100)}}}
             f (future.async (fn [] complex-data))
             result (f:await)]
         (assert.= (length complex-data.large-text) (length result.large-text))
         (assert.= 100 (length result.numbers))
         (assert.= 1 (. result.numbers 1))
         (assert.= 100 (. result.numbers 100))
         (assert.= (string.rep "nested" 100) result.nested.deep.data)))))

(fn test-internal-io-utilities []
  (testing "write-all handles partial writes correctly"
    #(do
       ;; Test write-all with small data
       (let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
             test-data "hello world"
             written (future.__internal__.write-all write-fd test-data)
             _ (rb.unix.close write-fd)
             result (future.__internal__.read-all read-fd)]
         (rb.unix.close read-fd)
         (assert.= (length test-data) written)
         (assert.= test-data result))
       
       ;; Test write-all with large data (>4KB)
       (let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
             large-data (string.rep "abcdefghij" 500)  ; 5000 bytes
             written (future.__internal__.write-all write-fd large-data)
             _ (rb.unix.close write-fd)  ; Signal EOF
             result (future.__internal__.read-all read-fd)]
         (rb.unix.close read-fd)
         (assert.= 5000 written)
         (assert.= 5000 (length result))
         (assert.= large-data result))
       
       ;; Test write-all with empty data
       (let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
             empty-data ""
             written (future.__internal__.write-all write-fd empty-data)
             _ (rb.unix.close write-fd)
             result (future.__internal__.read-all read-fd)]
         (rb.unix.close read-fd)
         (assert.= 0 written)
         (assert.= empty-data result))))
  
  (testing "read-all handles EOF and partial reads correctly"
    #(do
       ;; Test read-all with empty data
       (let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
             _ (rb.unix.close write-fd)  ; Immediate EOF
             result (future.__internal__.read-all read-fd)]
         (rb.unix.close read-fd)
         (assert.= "" result))
       
       ;; Test read-all with multiple writes
       (let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
             _ (rb.unix.write write-fd "part1")
             _ (rb.unix.write write-fd "part2") 
             _ (rb.unix.write write-fd "part3")
             _ (rb.unix.close write-fd)  ; Signal EOF
             result (future.__internal__.read-all read-fd)]
         (rb.unix.close read-fd)
         (assert.= "part1part2part3" result))))
  
  (testing "write-all and read-all integration with JSON"
    ;; Test round-trip with complex JSON data
    #(let [test-data {:numbers (fcollect [i 1 100] (* i i))
                      :text (string.rep "integration test " 50)
                      :nested {:deep {:value "success"}}}
           json-payload (rb.encode-json test-data)
           (read-fd write-fd) (_G.assert (rb.unix.pipe))
           written (future.__internal__.write-all write-fd json-payload)
           _ (rb.unix.close write-fd)
           received-json (future.__internal__.read-all read-fd)
           decoded-data (rb.decode-json received-json)]
       (rb.unix.close read-fd)
       (assert.= (length json-payload) written)
       (assert.= (length test-data.numbers) (length decoded-data.numbers))
       (assert.= (. test-data.numbers 1) (. decoded-data.numbers 1))
       (assert.= (. test-data.numbers 100) (. decoded-data.numbers 100))
       (assert.= test-data.text decoded-data.text)
       (assert.= test-data.nested.deep.value decoded-data.nested.deep.value))))
  
  (testing "write-all error handling"
    ;; Test writing to closed file descriptor
    #(let [(read-fd write-fd) (_G.assert (rb.unix.pipe))
           _ (rb.unix.close write-fd)
           (written err) (future.__internal__.write-all write-fd "test data")]
       (rb.unix.close read-fd)
       (assert.nil? written)
       (assert.ok err "Expected error when writing to closed fd")))

{: test-basic-future-operations
 : test-future-combinators
 : test-large-payload-handling
 : test-internal-io-utilities
 }
