(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : icons}
      (require :rv-config.heirline.common)

      ;; Signcolumn
      Signcolumn
      {:condition #(not= (vim.opt.signcolumn:get)
                         "no")
       :on_click {:name :sign_click
                  :callback
                    (fn [...]
                      (let []
                        nil))}}]

  {: Signcolumn})
