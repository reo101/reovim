(let [{: heirline
       : conditions
       : utils
       : colors
       : heirline-components
       : navic
       : luasnip
       : icons}
      (require :rv-config.heirline.common)

      ;;; Components

      {: Foldcolumn}
      (require "rv-config.heirline.components.foldcolumn")

      {: Numbercolumn}
      (require "rv-config.heirline.components.numbercolumn")

      {: Signcolumn}
      (require "rv-config.heirline.components.signcolumn")

      ;; DefaultStatuscolumn
      DefaultStatuscolumn
      (vim.tbl_extend
        :error
        {:init (fn [self]
                 (set self.bufnr
                      (vim.api.nvim_get_current_buf)))}
        [(heirline-components.component.foldcolumn)
         (heirline-components.component.signcolumn)
         (heirline-components.component.numbercolumn)])]

  {: DefaultStatuscolumn})
