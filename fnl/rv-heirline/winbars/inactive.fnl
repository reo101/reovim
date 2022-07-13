(let [{: heirline
       : conditions
       : utils
       : colors
       : gps
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-heirline.common)

      ;;; Components

      ;;; Winbar

      ;; Inactive Winbar
      InactiveWinbar
      {:init      (fn [self]
                    (set vim.opt_local.winbar nil))
       :condition (fn [self]
                    (conditions.buffer_matches
                      {:filetype [:^git.*
                                  :fugitive]
                       :buftype  [:nofile
                                  :prompt
                                  :help
                                  :terminal
                                  :quickfix]}))}]

  {: InactiveWinbar})
