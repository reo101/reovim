(let [{: luasnip}
      (require :rv-config.heirline.common)

      ;; Snippets
      Snippets
      {:condition (fn [self]
                    (luasnip.in_snippet))
       :provider  (fn [self]
                    (let [backward (if (luasnip.jumpable -1)
                                     " 󰍞"
                                     "")
                          forward  (if (luasnip.jumpable  1)
                                     " 󰍟"
                                     "")
                          choice   (if (luasnip.choice_active)
                                     " ?"
                                     "")]
                      (.. backward forward choice)))
       :hl        {:fg   :red
                   :bold true}}]

  {: Snippets})
