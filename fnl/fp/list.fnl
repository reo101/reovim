(import-macros
  {: mdo}
  :fp.mdo-macros)

(local
  {: has-type?}
  (require :typed-fennel))

(local List {})

(local List-mt
       {:__call
         (λ [self T]
           #(do
             (assert
               (List.list? $)
               "Not a result")
             (List.elim $ true
               #(and $1
                     (assert
                       (has-type? $2 T)
                       "Unexpected List element type")))))})
(setmetatable List List-mt)

;;; Validation
(fn List.list? [xs]
  (vim.tbl_islist xs))

;;; Construction
(fn List.new [...]
  (let [t (table.pack ...)]
    (tset t :n nil)
    (setmetatable t List-mt)
    t))

;;; Deconstruction
(fn List.elim [xs init f]
  (-> xs
      vim.iter
      (: :fold init f)))

;;; Functor
(fn List.map [xs f]
  (vim.tbl_map f xs))

;;; Monad
(fn List.pure [...]
  [...])
(fn List.join [xss]
  (local res [])
  (each [_ xs (ipairs xss)]
    (each [_ x (ipairs xs)]
      (table.insert res x)))
  res)
(fn List.>>= [xs f]
  (local res [])
  (each [_ x (ipairs xs)]
    (each [_ y (ipairs (f x))]
      (table.insert res y)))
  res)

;;; Miscellaneous
(fn List.empty []
  [])

List
