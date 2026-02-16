(fn _G.handle [co status ...]
  (when (not status)
    (error (tostring ...)))
  (if (= (coroutine.status co) :dead)
      ...
      (let [shift-func ...]
        (local captured-co (coroutine.clone co))
        (shift-func #(let [cloned-co (coroutine.clone captured-co)]
                       (_G.handle cloned-co (coroutine.resume cloned-co $)))))))

(macro reset [& body]
  `(do
    (local co# (coroutine.create #(do ,(unpack body))))
    (_G.handle co# (coroutine.resume co#))))

(macro shift [& body]
  `(coroutine.yield #(do ,(unpack body))))

(local result
  (reset
    (let [val (shift
                (print "Shift 1")
                (local res ($ 5))
                (print "Shift 2, k(5) returned" res)
                ($ res))]
      (print "Inside reset, val is" val)
      (+ val 1))))

(print "Delimited result:" result)
