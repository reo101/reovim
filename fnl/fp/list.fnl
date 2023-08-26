(import-macros
  {: mdo}
  :fp.mdo-macros)

(local List {})

;;; Validation
(fn List.list? [xs]
  (vim.is_list xs))

;;; Construction
(fn List.new [...]
  (let [t (table.pack ...)]
    (tset t :n nil)
    t))

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
