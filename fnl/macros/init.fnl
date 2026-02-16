;;; Global Macro Hub
;;; Flattens config macro modules into one normalized defs table for the loader.

(fn merge-into! [to from]
  (when (= (type from) :table)
    (each [name value (pairs from)]
      (tset to name value)))
  to)

(fn merge-defs! [acc defs]
  (merge-into! acc.specials defs.specials)
  (merge-into! acc.macros defs.macros)
  acc)

(let [defs {:specials {} :macros {}}]
  (merge-defs! defs (require :macros.jp))
  (merge-defs! defs (require :macros.typed-fennel))
  defs)
