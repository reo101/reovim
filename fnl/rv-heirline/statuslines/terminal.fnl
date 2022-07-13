(let [{: conditions
       : colors}
      (require :rv-heirline.common)

      ;;; Components

      ;; ViMode
      {: ViMode}
      (require :rv-heirline.components.vimode)

      ;; File-Block
      {: Filetype}
      (require :rv-heirline.components.file)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-heirline.components.align)

      ;;; Statusline

      ;; Terminal Statusline
      TerminalStatusline
      {:condition (fn [self]
                    (conditions.buffer_matches
                      {:buftype [:terminal]}))
       :hl        {:bg colors.dark_red}
       1 (unpack [{:condition conditions.is_active
                   1 (unpack [ViMode
                              Space])}
                  Filetype
                  Space
                  Terminal-Name
                  Align])}]

  {: TerminalStatusline})
