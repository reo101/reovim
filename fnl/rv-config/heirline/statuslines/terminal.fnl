(let [{: conditions
       : colors}
      (require :rv-config.heirline.common)

      ;;; Components

      ;; ViMode
      {: ViMode}
      (require :rv-config.heirline.components.vimode)

      ;; File-Block
      {: Filetype}
      (require :rv-config.heirline.components.file)

      ;; Terminal-Name
      {: Terminal-Name}
      (require :rv-config.heirline.components.terminal)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-config.heirline.components.align)

      ;;; Statusline

      ;; Terminal Statusline
      TerminalStatusline
      (vim.tbl_extend
        :error
        {:condition (fn [self]
                      (conditions.buffer_matches
                        {:buftype [:terminal]}))
         :hl        {:bg colors.dark_red}}
        [(vim.tbl_extend
           :error
           {:condition conditions.is_active}
           [ViMode
            Space])
         Filetype
         Space
         Terminal-Name
         Align])]

  {: TerminalStatusline})
