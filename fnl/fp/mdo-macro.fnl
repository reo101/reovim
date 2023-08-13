(fn mdo [dMonad ...]
  "Haskell's do notation"

 (local instructions [...])
 (let [len (length instructions)]
   (for [i (- len 1) 1 (- 1)]
     (tset instructions
           len
           (table.remove instructions i))))

 (local syms
        {:>>=  (gensym :>==)
         :pure (gensym :pure)})

 (var res nil)
 (match instructions
   (where [result & instrs] (= :table (type result)))
   (do
     (set res result)
     (each [_ instr (ipairs instrs)]
       (match instr
         ;;; Bind
         (where [[:<- nil] [x nil] mx nil]
                (= :string (type x)))
         (do
           (set res `(,syms.>>= ,mx (fn [,(sym x)] ,res))))
         ;;; Ignore Bind
         [mx]
         (do
           (set res `(,syms.>>= ,mx (fn [_#] ,res)))))))
   _
   (do
     (assert-compile false "Invalid form" [...])))
 `(when true
    (let [{:>>= ,syms.>>=
           :pure ,syms.pure} ,dMonad]
      ,res)))

;; (fn safe-div [x y]
;;   (if (= (% x y) 0)
;;       (Option.some (/ x y))
;;       (Option.none)))
;;
;; (print
;;   (mdo Option
;;     (<- a (Option.some 4))
;;     (<- a (safe-div a 2))
;;     (<- a (safe-div a 2))
;;     (Option.pure a)))
;;
;; (macrodebug
;;   (mdo Option
;;     (<- a (f a b))
;;     (mqu a b c)
;;     (pure mb)))

{: mdo}
