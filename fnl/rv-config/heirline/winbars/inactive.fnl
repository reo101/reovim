(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;;; Components

      ;;; Winbar

      ;; Inactive Winbar
      InactiveWinbar
      {:init      (fn [self]
                    (set vim.opt_local.winbar nil)
                    (vim.schedule
                      #(vim.cmd.redrawstatus)))
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
