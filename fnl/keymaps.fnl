(let [wk (require :which-key)
      mappings
      {:t {:name :Toggle
           :b [(fn []
                 (set vim.o.background
                       (if
                         (= vim.o.background :light)
                         :dark
                         :light)))
               "Background"]}}]
  (wk.register mappings {:prefix :<leader>}))
