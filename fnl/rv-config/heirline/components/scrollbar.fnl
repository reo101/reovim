(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : icons}
      (require :rv-config.heirline.common)

      ;; ScrollBar
      ScrollBar
      {:provider (fn [self]
                   (let [[line] (vim.api.nvim_win_get_cursor 0)
                         lines (vim.api.nvim_buf_line_count 0)
                         i (-> (/ line lines)
                               (* (- (length self.bar) 1))
                               (+ 1)
                               (math.floor))]
                     (string.rep (. self.bar i) 2)))
       :static   {:bar [:█ :▇ :▆ :▅ :▄ :▃ :▂ :▁]}}]

  {: ScrollBar})
