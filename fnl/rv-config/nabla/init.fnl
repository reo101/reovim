(fn config []
  (let [nabla (require :nabla)
        dk (require :def-keymaps)]
    ;; Customize with (nabla.popup {border ...}) ;; `single` (default), `double`, `rounded`
    ;; (nabla.popup {})

    (dk :n
        {:t {:name :Toggle
             :n [nabla.popup :Nable]}}
        {:prefix :<leader>})))

{1       :jbyuki/nabla.nvim
 :ft     ["tex"
          "latex"]
 : config}
