;; fennel-ls: macro-file

(fn mdo [dMonad ...]
  "Haskell's do notation"

  ;;; Reverse the instructions
  (local instructions [...])
  (let [len (length instructions)]
    (for [i (- len 1) 1 (- 1)]
      (tset instructions
            len
            (table.remove instructions i))))

  ;;; Generate symbols for bind and pure
  (local syms
         {:>>=  (gensym :_>>=)
          :pure (gensym :_pure)})

  (var res nil)
  (match instructions
    ;;; Last (now first) instruction is used as a result
    (where [result & instrs] (= :table (type result)))
    (do
      (set res result)
      (each [_ instr (ipairs instrs)]
        (match instr
          ;;; Bind (<- x mx)
          (where [[:<- nil] [x nil] mx nil]
                 (= :string (type x)))
          (do
            (set res `(,syms.>>= ,mx (fn [,(sym x)] ,res))))
          ;;; Ignore Bind (lone expression)
          [mx]
          (do
            (set res `(,syms.>>= ,mx (fn [_#] ,res)))))))
    ;;; Invalid form (no last instruction)
    _
    (do
      (assert-compile false "Invalid form" [...])))

  ;;; Output binds the used bind and pure functions
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
