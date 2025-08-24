(fn after []
  (let [nabla (require :nabla)
        dk (require :def-keymaps)]
    ;; Customize with (nabla.popup {border ...}) ;; `single` (default), `double`, `rounded`
    ;; (nabla.popup {})

    (dk :n
        {:t {:group :Toggle
             :n [nabla.popup :Nable]}}
        {:prefix :<leader>})))

{:src "https://github.com/jbyuki/nabla.nvim"
 :data {:ft     ["tex"
                 "latex"]
        : after}}
