(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;; ScrollBar
      ScrollBar
      {:provider (fn [self]
                   (local line  (. (vim.api.nvim_win_get_cursor 0) 1))
                   (local lines (vim.api.nvim_buf_line_count 0))
                   (local i
                     (->
                       (/ line lines)
                       (* (- (length self.bar) 1))
                       (+ 1)
                       (math.floor)))
                   (string.rep (. self.bar i) 2))
       :static   {:bar [:█ :▇ :▆ :▅ :▄ :▃ :▂ :▁]}}]

  {: ScrollBar})
