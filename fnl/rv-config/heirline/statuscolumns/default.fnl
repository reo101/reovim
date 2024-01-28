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

      {: Foldcolumn}
      (require "rv-config.heirline.components.foldcolumn")

      ;; {: Numbercolumn}
      ;; (require "rv-config.heirline.components.numbercolumn")

      ;; {: Signcolumn}
      ;; (require "rv-config.heirline.components.signcolumn")

      ;; DefaultStatuscolumn
      DefaultStatuscolumn
      {:init (fn [self]
               (= self.bufnr
                  (vim.api.nvim_get_current_buf)))
       1 (unpack [Foldcolumn])}]
                  ;; Fill
                  ;; Numbercolumn
                  ;; Signcolumn])}]

  {: DefaultStatuscolumn})
