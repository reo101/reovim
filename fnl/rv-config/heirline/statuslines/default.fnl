(let [{: conditions}
      (require :rv-config.heirline.common)

      ;;; Components

      ;; ViMode
      {: ViMode}
      (require :rv-config.heirline.components.vimode)

      ;; File-Block
      {: File-Block
       : Filetype}
      (require :rv-config.heirline.components.file)

      ;; Git
      {: Git}
      (require :rv-config.heirline.components.git)

      ;; Diagnostics
      {: Diagnostics}
      (require :rv-config.heirline.components.diagnostics)

      ;; DAP-Messages
      {: DAP-Messages}
      (require :rv-config.heirline.components.dap)

      ;; LSP-Active
      {: LSP-Active}
      (require :rv-config.heirline.components.lsp)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-config.heirline.components.align)

      ;; Ruler
      {: Ruler}
      (require :rv-config.heirline.components.ruler)

      ;; ScrollBar
      {: ScrollBar}
      (require :rv-config.heirline.components.scrollbar)

      ;;; Statusline

      ;; DefaultStatusline
      DefaultStatusline
      [ViMode Space
       File-Block Space
       Git Space
       Diagnostics Align

       DAP-Messages Align

       LSP-Active Space
       Filetype Space
       {:condition conditions.is_active
        1 (unpack [Spell
                   Space])}
       Ruler Space
       ScrollBar]]

  {: DefaultStatusline})
