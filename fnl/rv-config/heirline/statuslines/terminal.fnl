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

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-config.heirline.components.align)

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
