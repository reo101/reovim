(let [{: conditions}
      (require :rv-heirline.common)

      ;;; Components

      ;; ViMode
      {: ViMode}
      (require :rv-heirline.components.vimode)

      ;; File-Block
      {: File-Block
       : Filetype}
      (require :rv-heirline.components.file)

      ;; Git
      {: Git}
      (require :rv-heirline.components.git)

      ;; Diagnostics
      {: Diagnostics}
      (require :rv-heirline.components.diagnostics)

      ;; DAP-Messages
      {: DAP-Messages}
      (require :rv-heirline.components.dap)

      ;; LSP-Active
      {: LSP-Active}
      (require :rv-heirline.components.lsp)

      ;; Align & Space
      {: Align
       : Space}
      (require :rv-heirline.components.align)

      ;; Ruler
      {: Ruler}
      (require :rv-heirline.components.ruler)

      ;; ScrollBar
      {: ScrollBar}
      (require :rv-heirline.components.scrollbar)

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
