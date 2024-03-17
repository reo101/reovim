(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      get-current-char
      (fn []
        (let [{: screenrow
               : screencol
               : winid
               : line} (vim.fn.getmousepos)
              char (vim.fn.screenstring
                     screenrow
                     (- screencol 1))]
          (vim.api.nvim_set_current_win winid)
          (vim.api.nvim_win_set_cursor 0 [line 0])
          char))

      ;; Foldcolumn
      Foldcolumn
      {:condition #(not= (vim.opt.foldcolumn:get)
                         "0")
       :on_click {:name :fold_click
                  :callback
                    (fn [...]
                      (let [char (get-current-char)
                            fillchars (vim.opt_local.fillchars:get)]
                        (if
                          (= char (when fillchars.foldopen ""))
                          (vim.cmd "normal! zc")
                          (= char (when fillchars.foldclose ""))
                          (vim.cmd "normal! zo"))))}}]

  {: Foldcolumn})
