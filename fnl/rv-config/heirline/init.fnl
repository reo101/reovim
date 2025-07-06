(fn after []
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

        ;;; Tablines

        {: DefaultTabline}
        (require :rv-config.heirline.tablines.default)

        ;;; Statuscolumns

        {: DefaultStatuscolumn}
        (require :rv-config.heirline.statuscolumns.default)

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
          ;; TODO: winbars for inactive buffers + terminal
          [DefaultWinbar])

        ;; Tabline
        Tabline
        (vim.tbl_extend
          :error
          {}
          [DefaultTabline])

        ;; Statuscolumn
        Statuscolumn
        (vim.tbl_extend
          :error
          {}
          [DefaultStatuscolumn])]
    (fn setup-colors []
      (collect [color highlight
                (pairs
                  {:blue       :Function
                   :bright_bg  :Folded
                   :bright_fg  :Folded
                   :cyan       :Special
                   :dark_red   :DiffDelete
                   :diag_error :DiagnosticError
                   :diag_hint  :DiagnosticHint
                   :diag_info  :DiagnosticInfo
                   :diag_warn  :DiagnosticWarn
                   :git_add    :diffAdded
                   :git_change :diffChanged
                   :git_del    :diffDeleted
                   :gray       :NonText
                   :green      :String
                   :orange     :Constant
                   :purple     :Statement
                   :red        :DiagnosticError})]
        (values
          color
          (. (utils.get_highlight highlight)
             :fg))))

    (heirline-components.init.subscribe_to_events)
    ; (heirline.load_colors (heirline-components.hl.get_colors))
    (heirline.setup {:statusline   Statusline
                     :winbar       Winbar
                     :tabline      Tabline
                     :statuscolumn Statuscolumn
                     :opts {:colors setup-colors
                            :disable_winbar_cb
                              (fn [{: buf}]
                                (or (-> buf
                                        vim.api.nvim_buf_get_name
                                        (vim.startswith "hunk://")
                                        not)
                                    (conditions.buffer_matches
                                      {:filetype [:^git.*
                                                  :fugitive]
                                       :buftype  [:nofile
                                                  :prompt
                                                  :help
                                                  :terminal
                                                  :quickfix]}
                                      buf)))}})

    (let [group (vim.api.nvim_create_augroup
                   :Heirline
                   {:clear true})]
      (vim.api.nvim_create_autocmd
        :FileType
        {: group
         ;; :command "if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif"
         :callback #(when (vim.tbl_contains [:wipe :delete] vim.bo.bufhidden)
                      (set vim.bo.buflisted false))})
      (vim.api.nvim_create_autocmd
        :ColorScheme
        {:callback #(utils.on_colorscheme setup-colors)
         : group}))))

[{:src "https://github.com/SmiteshP/nvim-navic"
  :data {:dep_of [:heirline.nvim]}}
 {:src "https://github.com/Zeioth/heirline-components.nvim"
  :data {:dep_of [:heirline.nvim]}}
 {:src "https://github.com/rebelot/heirline.nvim"
  :data {:event :DeferredUIEnter
         : after}}]
