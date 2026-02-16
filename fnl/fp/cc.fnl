(local request-tag {})

(fn passthrough [...]
  ...)

(fn drive [co status ...]
  (when (not status)
    (error (tostring ...)))
  (if (= (coroutine.status co) :dead)
      ...
      (let [suspended ...
            captured-co (coroutine.clone co)]
        (suspended
          #(let [cloned-co (coroutine.clone captured-co)]
             (drive cloned-co (coroutine.resume cloned-co $...)))))))

(fn run [thunk]
  (local co (coroutine.create thunk))
  (drive co (coroutine.resume co)))

(fn suspend [f]
  (coroutine.yield f))

(macro reset [& body]
  `(run #(do ,(unpack body))))

(macro shift [& body]
  `(suspend #(do ,(unpack body))))

(fn request? [value]
  (and (= :table (type value))
       (rawequal (. value :__cc) request-tag)))

(fn make-request [effect op args resume]
  {:__cc request-tag
   : effect
   : op
   : args
   : resume})

(fn perform [effect op ...]
  (local args [...])
  (suspend (fn [k]
             (make-request effect op args k))))

(fn operation [effect op]
  #(perform effect op $...))

(fn make-effect [effect ops]
  (let [res {: effect}]
    (collect [_ op (ipairs ops) &into res]
      (values op (operation effect op)))
    res))

(fn with-handler [handler thunk]
  (let [handled-effect (or (. handler :effect)
                           (. handler :name))
        ops (or (. handler :operations)
                (. handler :ops)
                {})
        on-return (or (. handler :return) passthrough)
        on-finally (or (. handler :finally) passthrough)]
    (fn loop [result ...]
      (if (request? result)
          (let [{: effect
                 : op
                 : args
                 : resume} result
                op-handler (and (or (= nil handled-effect)
                                    (= handled-effect effect))
                                (. ops op))]
            (if op-handler
                (op-handler
                  {: effect
                   : op
                   : args
                   :resume #(loop (resume $...))})
                (make-request
                  effect
                  op
                  args
                  #(loop (resume $...)))))
          (on-return result ...)))
    (on-finally (loop (run thunk)))))

(local Random
       (make-effect :random [:flip]))

(local handlers
       {:random
        {:io
          {:effect :random
           :operations
             {:flip #($.resume (= 1 (math.random 2)))}}
         :choices
          {:effect :random
           :return #[$]
           :operations
             {:flip #(-> [true false]
                         vim.iter
                         (: :map $.resume)
                         (: :flatten)
                         (: :totable))}}
         :tree
          {:effect :random
           :operations
             {:flip #{true  ($.resume true)
                      false ($.resume false)}}}}})

(fn sample-random-program []
  (local flip Random.flip)
  (let [left (flip)
        right (flip)]
    (+ (if left 1 0)
       (if right 1 0))))

(comment
  (local result
         (reset
           (let [val (shift
                       (print "Shift 1")
                       (local resumed ($ 5))
                       (print "Shift 2, k(5) returned" resumed)
                       ($ resumed))]
             (print "Inside reset, val is" val)
             (+ val 1))))
  (print "Delimited result:" result)

  (print "Random IO:" (with-handler handlers.random.io sample-random-program))
  (print "All random outcomes:" (vim.inspect (with-handler handlers.random.choices sample-random-program)))
  (print "Random tree:" (vim.inspect (with-handler handlers.random.tree sample-random-program))))

{: run
 : suspend
 : perform
 : operation
 : make-effect
 : request?
 : with-handler
 : Random
 : handlers
 : sample-random-program}
