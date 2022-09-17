(fn config []
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

        ;; ViMode
        {: ViMode}
        (require :rv-heirline.components.vimode)

        ;; File-Block
        {: File-Block
         : Filetype
         : Filename
         : Filetype-Icon}
        (require :rv-heirline.components.file)

        ;; Ruler
        {: Ruler}
        (require :rv-heirline.components.ruler)

        ;; ScrollBar
        {: ScrollBar}
        (require :rv-heirline.components.scrollbar)

        ;; LSP-Active
        {: LSP-Active}
        (require :rv-heirline.components.lsp)

        ;; Diagnostics
        {: Diagnostics}
        (require :rv-heirline.components.diagnostics)

        ;; Git
        {: Git}
        (require :rv-heirline.components.git)

        ;; DAP-Messages
        {: DAP-Messages}
        (require :rv-heirline.components.dap)

        ;; Workdir
        {: Work-Dir}
        (require :rv-heirline.components.workdir)

        ;; Terminal-Name
        {: Terminal-Name}
        (require :rv-heirline.components.terminal)

        ;; Help-Filename
        {: Help-Filename}
        (require :rv-heirline.components.help)

        ;; Snippets
        {: Snippets}
        (require :rv-heirline.components.snippets)

        ;; Spell
        {: Spell}
        (require :rv-heirline.components.spell)

        ;; Gps
        {: Gps}
        (require :rv-heirline.components.gps)

        ;; Navic
        {: Navic}
        (require :rv-heirline.components.navic)

        ;; Location
        {: Location}
        (require :rv-heirline.components.location)

        ;; Align & Space
        {: Align
         : Space}
        (require :rv-heirline.components.align)

        ;;; Statuslines

        ;; Default Statusline
        {: DefaultStatusline}
        (require :rv-heirline.statuslines.default)

        ;; Inactive Statusline
        {: InactiveStatusline}
        (require :rv-heirline.statuslines.inactive)

        ;; Special Statusline
        {: SpecialStatusline}
        (require :rv-heirline.statuslines.special)

        ;; Terminal Statusline
        {: TerminalStatusline}
        (require :rv-heirline.statuslines.terminal)

        ;;; Winbars

        ;; Default Winbar
        {: DefaultWinbar}
        (require :rv-heirline.winbars.default)

        ;; Inactive Winbar
        {: InactiveWinbar}
        (require :rv-heirline.winbars.inactive)

        ;;; Tablines

        {: DefaultTabline}
        (require :rv-heirline.tablines.default)

        ;;; Final

        ;; Statusline
        Statusline
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
                  :bg (. (utils.get_highlight :StatusLineNC) :bg)}))
         1 (unpack [SpecialStatusline
                    TerminalStatusline
                    InactiveStatusline
                    DefaultStatusline])}

        ;; Winbar
        Winbar
        {:fallthrough false
         1 (unpack [InactiveWinbar
                    DefaultWinbar])}

        ;; Tabline
        Tabline
        {1 (unpack [DefaultTabline])}]
    (heirline.setup Statusline Winbar Tabline)
    (vim.cmd "au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif")))

{: config}
