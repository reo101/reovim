(fn config []
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

        ;; ViMode
        {: ViMode}
        (require :rv-config.heirline.components.vimode)

        ;; File-Block
        {: File-Block
         : Filetype
         : Filename
         : Filetype-Icon}
        (require :rv-config.heirline.components.file)

        ;; Ruler
        {: Ruler}
        (require :rv-config.heirline.components.ruler)

        ;; ScrollBar
        {: ScrollBar}
        (require :rv-config.heirline.components.scrollbar)

        ;; LSP-Active
        {: LSP-Active}
        (require :rv-config.heirline.components.lsp)

        ;; Diagnostics
        {: Diagnostics}
        (require :rv-config.heirline.components.diagnostics)

        ;; Git
        {: Git}
        (require :rv-config.heirline.components.git)

        ;; DAP-Messages
        {: DAP-Messages}
        (require :rv-config.heirline.components.dap)

        ;; Workdir
        {: Work-Dir}
        (require :rv-config.heirline.components.workdir)

        ;; Terminal-Name
        {: Terminal-Name}
        (require :rv-config.heirline.components.terminal)

        ;; Help-Filename
        {: Help-Filename}
        (require :rv-config.heirline.components.help)

        ;; Snippets
        {: Snippets}
        (require :rv-config.heirline.components.snippets)

        ;; Spell
        {: Spell}
        (require :rv-config.heirline.components.spell)

        ;; Navic
        {: Navic}
        (require :rv-config.heirline.components.navic)

        ;; Location
        {: Location}
        (require :rv-config.heirline.components.location)

        ;; Align & Space
        {: Align
         : Space}
        (require :rv-config.heirline.components.align)

        ;;; Statuslines

        ;; Default Statusline
        {: DefaultStatusline}
        (require :rv-config.heirline.statuslines.default)

        ;; Inactive Statusline
        {: InactiveStatusline}
        (require :rv-config.heirline.statuslines.inactive)

        ;; Special Statusline
        {: SpecialStatusline}
        (require :rv-config.heirline.statuslines.special)

        ;; Terminal Statusline
        {: TerminalStatusline}
        (require :rv-config.heirline.statuslines.terminal)

        ;;; Winbars

        ;; Default Winbar
        {: DefaultWinbar}
        (require :rv-config.heirline.winbars.default)

        ;; Inactive Winbar
        {: InactiveWinbar}
        (require :rv-config.heirline.winbars.inactive)

        ;;; Tablines

        {: DefaultTabline}
        (require :rv-config.heirline.tablines.default)

        ;;; Final

        ;; Statusline
        Statusline
        (vim.tbl_extend
          :error
          {:fallthrough false
           :static {:mode-colors {:n     colors.red
                                  :i     colors.green
                                  :v     colors.cyan
                                  :V     colors.cyan
                                  "\022" colors.cyan
                                  :c     colors.orange
                                  :s     colors.purple
                                  :S     colors.purple
                                  "\019" colors.purple
                                  :R     colors.orange
                                  :r     colors.orange
                                  :!     colors.red
                                  :t     colors.green}
                    :mode-color  (fn [self]
                                   (let [mode (or (and (conditions.is_active)
                                                       (vim.fn.mode))
                                                  :n)]
                                     (. self.mode-colors mode)))}
           :hl (fn [self]
                 (if (conditions.is_active)
                   {:fg (. (utils.get_highlight :StatusLine)   :fg)
                    :bg (. (utils.get_highlight :StatusLine)   :bg)}
                   {:fg (. (utils.get_highlight :StatusLineNC) :fg)
                    :bg (. (utils.get_highlight :StatusLineNC) :bg)}))}
          [SpecialStatusline
           TerminalStatusline
           InactiveStatusline
           DefaultStatusline])

        ;; Winbar
        Winbar
        (vim.tbl_extend
          :error
          {:fallthrough false}
          [InactiveWinbar
           DefaultWinbar])

        ;; Tabline
        Tabline
        (vim.tbl_extend
          :error
          {}
          [DefaultTabline])]
    (heirline.setup {:statusline Statusline
                     :winbar Winbar
                     :statuscolumn nil
                     :tabline Tabline})
    (vim.cmd "au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif")))

{: config}
