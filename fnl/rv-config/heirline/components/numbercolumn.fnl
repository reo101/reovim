(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;; Numbercolumn
      Numbercolumn
      {:condition #(or (vim.opt.number:get)
                       (vim.opt.relativenumber:get))
       :on_click {:name :number_click
                  :callback
                    (fn [...]
                      (let []
                        nil))}}]

  {: Numbercolumn})
