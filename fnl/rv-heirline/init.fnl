(fn config []
  (let [heirline   (require :heirline)
        conditions (require :heirline.conditions)
        utils      (require :heirline.utils)
        colors     {:red    (. (utils.get_highlight :DiagnosticError) :fg)
                    :green  (. (utils.get_highlight :String)          :fg)
                    :blue   (. (utils.get_highlight :Function)        :fg)
                    :gray   (. (utils.get_highlight :NonText)         :fg)
                    :orange (. (utils.get_highlight :DiagnosticWarn)  :fg)
                    :purple (. (utils.get_highlight :Statement)       :fg)
                    :cyan   (. (utils.get_highlight :Special)         :fg)
                    :diag   {:warn  (. (utils.get_highlight :DiagnosticWarn)  :fg)
                             :error (. (utils.get_highlight :DiagnosticError) :fg)
                             :hint  (. (utils.get_highlight :DiagnosticHint)  :fg)
                             :info  (. (utils.get_highlight :DiagnosticInfo)  :fg)}
                    :git    {:del    (. (utils.get_highlight :diffRemoved) :fg)
                             :add    (. (utils.get_highlight :diffAdded)   :fg)
                             :change (. (utils.get_highlight :diffChanged) :fg)}}
        gps     (require :nvim-gps)
        navic   (require :nvim-navic)
        luasnip (require :luasnip)
        ;; neogit  (require :neogit)
        dap     (require :dap)
        icons   (require :nvim-web-devicons)

        ;;; Components

        ;; ViMode
        ViMode
        {:init     (fn [self]
                     (set self.mode (vim.fn.mode 1))
                     (when (not self.once)
                      (vim.api.nvim_create_autocmd
                        :ModeChanged
                        {:command :redrawstatus})
                      (set self.once true)))
         :static   {:mode-names {:n       :N
                                 :no      :N?
                                 :nov     :N?
                                 :noV     :N?
                                 "no\022" :N?
                                 :niI     :Ni
                                 :niR     :Nr
                                 :niV     :Nv
                                 :nt      :Nt
                                 :v       :V
                                 :vs      :Vs
                                 :V       :V_
                                 :Vs      :Vs
                                 "\022"   :^V
                                 "\022s"  :^V
                                 :s       :S
                                 :S       :S_
                                 "\019"   :^S
                                 :i       :I
                                 :ic      :Ic
                                 :ix      :Ix
                                 :R       :R
                                 :Rc      :Rc
                                 :Rx      :Rx
                                 :Rv      :Rv
                                 :Rvc     :Rv
                                 :Rvx     :Rv
                                 :c       :C
                                 :cv      :Ex
                                 :r       "..."
                                 :rm      :M
                                 :r?      "?"
                                 :!       "!"
                                 :t       :T}}
         :provider (fn [self]
                     (.. " %2(" (. self.mode-names self.mode) "%)"))
         :hl       (fn [self]
                     (let [color (self:mode-color)]
                       {:bg      color
                        :fg      :black
                        :bold    true}))}

        ;; File-Block
        File-Block
        {:init (fn [self]
                 (set self.filename (vim.api.nvim_buf_get_name 0)))}

        ;; Filename-Icon
        Filetype-Icon
        {:init     (fn [self]
                     (local filename self.filename)
                     (local extension (vim.fn.fnamemodify filename ":e"))
                     (set-forcibly!
                       (self.icon self.icon_color)
                       (icons.get_icon_color
                        filename
                        extension
                        {:default true})))
         :provider (fn [self]
                     (and self.icon (.. self.icon " ")))
         :hl       (fn [self]
                     {:fg self.icon_color})}

        ;; Filename
        Filename
        {:condition (fn [self]
                      (not= (vim.fn.fnamemodify self.filename ":.") :null))
         :provider (fn [self]
                     (let [filename (vim.fn.fnamemodify self.filename ":.")]
                       (if
                         (= filename "")
                         "[No Name]"
                         (not (conditions.width_percent_below
                                (length filename)
                                0.25))
                         (vim.fn.pathshorten filename)
                         ;; Else
                         filename)))
         :hl       {:fg (. (utils.get_highlight :Directory) :fg)}}

        ;; FileFlags
        File-Flags
        [{:provider (fn [self]
                      (if (or (not vim.bo.modifiable)
                              vim.bo.readonly)
                        ""))
          :hl       {:fg colors.green}}
         {:provider (fn [self]
                      (if vim.bo.modified
                        "[+]"))
          :hl       {:fg colors.orange}}]

        ;; FilenameModifer
        Filename-Modifer
        {:hl (fn [self]
               (if vim.bo.modified
                 {:fg    colors.cyan
                  :bold  true
                  :force true}))}

        ;; Filetype
        Filetype
        {:provider (fn [self]
                     (string.upper vim.bo.filetype))

         :hl       {:fg   (. (utils.get_highlight :Type) :fg)
                    :bold true}}

        ;; File-Encoding
        File-Encoding
        {:provider (fn [self]
                    (let [enc (or (and (not= vim.bo.fenc "")
                                       vim.bo.fenc)
                                  vim.o.enc)]
                     (and (not= enc :utf-8) (enc:upper))))}

        ;; File-Format
        File-Format
        {:provider (fn [self]
                     (let [fmt vim.bo.fileformat]
                       (and (not= fmt :unix) (fmt:upper))))}

        ;; File-LastModified
        File-LastModified
        {:provider (fn [self]
                     (let [ftime (vim.fn.getftime
                                   (vim.api.nvim_buf_get_name
                                     0))]
                       (and (> ftime 0) (os.date :%c ftime))))}

        ;; File-Block
        File-Block
        (utils.insert
          File-Block
          Filetype-Icon
          Filename
          (unpack File-Flags)
          Filename-Modifer
          File-Encoding
          File-Format
          {:provider :%<})

        ;; Ruler
        Ruler
        {:provider "%7(%l/%3L%):%2c %P"}

        ;; ScrollBar
        ScrollBar
        {:provider (fn [self]
                     (local line  (. (vim.api.nvim_win_get_cursor 0) 1))
                     (local lines (vim.api.nvim_buf_line_count 0))
                     (local i
                       (->
                         (/ line lines)
                         (* (- (length self.bar) 1))
                         (+ 1)
                         (math.floor)))
                     (string.rep (. self.bar i) 2))
         :static   {:bar [:█ :▇ :▆ :▅ :▄ :▃ :▂ :▁]}}

        ;; LSP-Active
        LSP-Active
        {:condition conditions.lsp_attached
         :update    [:LspAttach
                     :LspDetach]
         :provider  (fn [self]
                      (let [names {}]
                        (each [i server (pairs (vim.lsp.buf_get_clients 0))]
                          (table.insert names server.name))
                        (.. " [" (table.concat names ", ") "]")))
         :hl        {:fg   colors.green
                     :bold true}}

        ;; Diagnostics
        Diagnostics
        {:init      (fn [self]
                      ;; TODO: macro this V
                      (set self.errors
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.ERROR})))
                      (set self.warnings
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.WARN})))
                      (set self.hints
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.HINT})))
                      (set self.info
                           (length (vim.diagnostic.get
                                     0
                                     {:severity vim.diagnostic.severity.INFO}))))
         :update    [:DiagnosticChanged
                     :BufEnter]
         :condition conditions.has_diagnostics
         ;; TODO: macro this V
         :static    {:error_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignError)
                                       1)
                                    :text)
                     :info_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignInfo)
                                      1)
                                   :text)
                     :hint_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignHint)
                                      1)
                                   :text)
                     :warn_icon (. (. (vim.fn.sign_getdefined :DiagnosticSignWarn)
                                      1)
                                   :text)}
         ;; TODO: macro this V
         1 (unpack [{:provider "!["}
                    {:condition (fn [self]
                                  (> self.errors 0))
                     1 {:provider (fn [self]
                                    self.error_icon)}
                     2 {:provider (fn [self]
                                    (.. self.errors " "))}
                     :hl       {:fg colors.diag.error}}
                    {:condition (fn [self]
                                  (> self.warnings 0))
                     1 {:provider (fn [self]
                                    self.warn_icon)}
                     2 {:provider (fn [self]
                                    (.. self.warnings " "))}
                     :hl       {:fg colors.diag.warn}}
                    {:condition (fn [self]
                                  (> self.info 0))
                     1 {:provider (fn [self]
                                    self.info_icon)}
                     2 {:provider (fn [self]
                                    (.. self.warnings " "))}
                     :hl       {:fg colors.diag.info}}
                    {:condition (fn [self]
                                  (> self.hints 0))
                     1 {:provider (fn [self]
                                    self.hint_icon)}
                     2 {:provider (fn [self]
                                    (.. self.hints " "))}
                     :hl       {:fg colors.diag.hint}}
                    {:provider "]"}])}

        ;; Git
        Git
        {:condition conditions.is_git_repo
         :init      (fn [self]
                      (set self.status_dict
                           vim.b.gitsigns_status_dict)
                      (set self.has_changes
                           (or (not= self.status_dict.added   0)
                               (not= self.status_dict.removed 0)
                               (not= self.status_dict.changed 0))))
         :hl        {:fg colors.orange}
         ;; :on_click  {:name     :heirline-git
         ;;             :callback (fn [self]
         ;;                         (vim.defer_fn neogit.open))}
         1 (unpack [{:provider (fn [self]
                                 (.. " " self.status_dict.head " "))
                     :hl       {:bold true}}
                    {:condition (fn [self]
                                  self.has_changes)
                     :provider  "("}
                    {:provider (fn [self]
                                 (let [count (or self.status_dict.added 0)]
                                   (and (> count 0)
                                        (.. "+" count))))
                     :hl       {:fg colors.git.add}}
                    {:provider (fn [self]
                                 (let [count (or self.status_dict.removed 0)]
                                   (and (> count 0)
                                        (.. "-" count))))
                     :hl       {:fg colors.git.del}}
                    {:provider (fn [self]
                                 (let [count (or self.status_dict.changed 0)]
                                   (and (> count 0)
                                        (.. "~" count))))
                     :hl       {:fg colors.git.change}}
                    {:condition (fn [self]
                                  self.has_changes)
                     :provider  ")"}])}

        ;; DAP-Messages
        DAP-Messages
        {:condition (fn [self]
                      (let [session (dap.session)]
                        (if session
                          (let [filename (vim.api.nvim_buf_get_name 0)]
                            (if session.config
                              (let [progname session.config.progname]
                                (= filename progname))
                              false))
                          false)))}

        ;; Work-Dir
        Work-Dir
        {:provider (fn [self]
                     (local icon
                       (.. (or (and (= (vim.fn.haslocaldir 0) 1)
                                    :l)
                               :g)
                           " "
                           " "))
                     (var cwd (vim.fn.getcwd 0))
                     (set cwd (vim.fn.fnamemodify cwd ":~"))
                     (when (not (conditions.width_percent_below (length cwd)
                                                                0.25))
                       (set cwd (vim.fn.pathshorten cwd)))
                     (local trail
                       (or (and (= (cwd:sub (- 1)) "/") "") "/"))
                     (.. icon cwd trail))
         :hl       {:fg   colors.blue
                    :bold true}}

        ;; Flexible Work-Dir
        Work-Dir-Flexible
        (utils.make_flexible_component
          1
          ;; evaluates to the full-lenth path
          {:provider (fn [self]
                       (local trail
                         (or (and (= (self.cwd:sub (- 1))
                                     "/")
                                  "")
                             "/"))
                       (.. self.icon self.cwd trail " "))}
          ;; evaluates to the shortened path
          {:provider (fn [self]
                       (local cwd
                         (vim.fn.pathshorten self.cwd))
                       (local trail
                         (or (and (= (self.cwd:sub (- 1))
                                     "/")
                                  "")
                             "/"))
                       (.. self.icon cwd trail " "))}
          ;; evaluates to "", hiding the component
          {:provider ""})

        ;; Terminal-Name
        Terminal-Name
        {:provider (fn [self]
                     (let [(tname _)
                           (: (vim.api.nvim_buf_get_name 0) :gsub
                              ".*;"
                              "")]
                       (.. " " tname)))
         :hl       {:fg   colors.blue
                    :bold true}}

        ;; Help-Filename
        Help-Filename
        {:hl        {:fg colors.blue}
         :condition (fn [self]
                      (= vim.bo.filetype :help))
         :provider  (fn [self]
                      (let [filename (vim.api.nvim_buf_get_name 0)]
                        (vim.fn.fnamemodify filename ":t")))}

        ;; Snippets
        Snippets
        {:condition (fn [self]
                      (luasnip.in_snippet))
         :provider  (fn [self]
                      (let [backward (if (luasnip.jumpable -1)
                                       " "
                                       "")
                            forward  (if (luasnip.jumpable  1)
                                       " "
                                       "")
                            choice   (if (luasnip.choice_active)
                                       " ?"
                                       "")]
                        (.. backward forward choice)))
         :hl        {:fg   :red
                     :bold true}}

        ;; Spell
        Spell
        {:condition (fn [self]
                      vim.wo.spell)
         :provider  "SPELL "
         :hl        {:fg   colors.orange
                     :bold true}}

        ;; Gps
        Gps
        {:static {:type_hl {}}
         :condition gps.is_available
         :init (fn [self]
                 (local data (or (gps.get_data) {}))
                 (local children {})
                 (each [i d (ipairs data)]
                   (let [child [{:provider d.icon
                                 :hl       (. self.type_hl d.type)}
                                {:provider d.text
                                 :hl       {:fg colors.cyan}}]]
                        ;; Add separator on all but the last child
                     (when (and (> (length data) 1)
                                (< i (length data)))
                       (table.insert child {:provider " > "
                                            :hl       {:fg colors.orange}}))
                     (table.insert children child)))
                 (tset self 1 (self:new children 1)))}

        ;; Navic
        Navic
        {:static {:type_hl {:File          :Directory
                            :Module        :Include
                            :Namespace     :TSNamespace
                            :Package       :Include
                            :Class         :Struct
                            :Method        :Method
                            :Property      :TSProperty
                            :Field         :TSField
                            :Constructor   :TSConstructor
                            :Enum          :TSField
                            :Interface     :Type
                            :Function      :Function
                            :Variable      :TSVariable
                            :Constant      :Constant
                            :String        :String
                            :Number        :Number
                            :Boolean       :Boolean
                            :Array         :TSField
                            :Object        :Type
                            :Key           :TSKeyword
                            :Null          :Comment
                            :EnumMember    :TSField
                            :Struct        :Struct
                            :Event         :Keyword
                            :Operator      :Operator
                            :TypeParameter :Type}}
              :condition (fn [self]
                           (and (navic.is_available)
                                (not= (navic.get_data) {})))
              :hl {:fg :gray}
              :init (fn [self]
                      (local data (or (navic.get_data) {}))
                      (local children {})
                      (each [i d (ipairs data)]
                        (local child
                          [{:provider d.icon
                            :hl       (. self.type_hl d.type)}
                           {:provider d.name
                            :hl       {:fg colors.cyan}}])
                        ;; Add separator on all but the last child
                        (when (and (> (length data) 1)
                                   (< i (length data)))
                          (table.insert child {:provider " > "
                                               :hl       {:fg colors.orange}}))
                        (table.insert children child))
                      (tset self 1 (self:new children 1)))}

        RelativePath
        {:init      (fn [self]
                      (let [buf-name  (vim.api.nvim_buf_get_name 0)
                            filename  (vim.fn.fnamemodify buf-name ":t")
                            extension (vim.fn.fnamemodify filename ":e")
                            (icon icon_color) (icons.get_icon_color
                                                filename
                                                extension
                                                {:default true})
                            path (vim.fn.fnamemodify buf-name ":~:.:h")
                            path (if
                                   (= path "")
                                   :.
                                   (not (conditions.width_percent_below
                                          (length path)
                                          0.4))
                                   (vim.fn.fnamemodify path ":t")
                                   ;; Else
                                   path)
                            directories (string.gmatch path "([^/]+)")
                            components {}]
                        (each [directory directories]
                          (table.insert components {:provider directory
                                                    :hl       {:fg colors.blue}})
                          (table.insert components {:provider " / "
                                                    :hl       {:fg colors.orange}}))
                        (table.insert components {:provider (fn [self]
                                                              (and icon
                                                                   (.. icon " ")))
                                                  :hl       {:fg icon_color}})
                        (table.insert components {:provider (fn [self]
                                                              filename)
                                                  :hl       {:fg icon_color}})
                        (tset self 1 (self:new components 1))))
         :condition (fn [self]
                      (not= (vim.api.nvim_buf_get_name 0) ""))}

        ;; RelativePath
        RelativePath
        (utils.insert
          RelativePath
          (unpack [{:provider (fn [self]
                                (string.gsub (.. self.path :/) "/" " / "))
                    :hl       {:fg colors.blue}}
                   {:provider (fn [self]
                                (and self.icon
                                     (.. self.icon " ")))
                    :hl       (fn [self]
                                {:fg self.icon_color})}
                   {:provider (fn [self]
                                self.filename)
                    :hl       {:fg colors.orange}}]))

        ;; Location
        Location
        {1 (unpack [RelativePath
                    {:condition (fn [self]
                                  (and
                                    (RelativePath.condition)
                                    (or (Navic.condition)
                                        (and (not (Navic.condition))
                                             (Gps.condition)))))
                     :provider  " >=> "
                     :hl        {:fg colors.red}}
                    {:init utils.pick_child_on_condition
                     1 (unpack [Navic
                                Gps])}])}

        ;; Align
        Align
        {:provider "%="}

        ;; Space
        Space
        {:provider " "}

        ViMode
        (utils.surround
          ["" ""]
          (fn [self]
            (self:mode-color))
          [ViMode
           Snippets])

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
         ScrollBar]

        InactiveStatusline
        {:condition (fn [self]
                      (not (conditions.is_active)))
         1 (unpack [Filetype
                    Space
                    Filename
                    Align])}

        SpecialStatusline
        {:condition (fn [self]
                      (conditions.buffer_matches
                        {:buftype [:nofile
                                   :prompt
                                   :help
                                   :quickfix]
                         :filetype [:^.git.*]}))
         1 (unpack [Filetype
                    Space
                    Filename
                    Align])}

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
                    Align])}

        ;;; Final

        ;; StatusLines
        StatusLines
        {:init   utils.pick_child_on_condition
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

        ;; WinBars
        WinBars
        {:init utils.pick_child_on_condition
         1 (unpack [{:init      (fn [self]
                                  (set vim.opt_local.winbar nil))
                     :condition (fn [self]
                                  (conditions.buffer_matches
                                    {:filetype [:^git.*
                                                :fugitive]
                                     :buftype  [:nofile
                                                :prompt
                                                :help
                                                :terminal
                                                :quickfix]}))}
                    ;; ;; Stock
                    ;; Location

                    ;; ;; Centered
                    ;; [Align
                    ;;  Location
                    ;;  Align]

                    ;; Bubble
                    [Align
                     (utils.surround
                       ["" ""]
                       (fn [self]
                         (. (utils.get_highlight :StatusLine) :bg))
                       (unpack [Location]))
                     Align]])}]
    (heirline.setup StatusLines WinBars)))

{: config}
