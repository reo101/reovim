(import-macros
  {: -m>
   : as->
   : imap}
  :init-macros)

;; Pretty to clockwise
(fn reorder-border [pretty]
  ;;
  ;;  ["╭" "─" "╮"
  ;;   "│"     "│"
  ;;   "╰" "─" "╯"]
  ;;  1 2 3 8 4 7 6 5
  ;;
  ;; VVVVVVVVVVVVVVVVV
  ;;
  ;;  ["╭" "─" "╮" "│" "╯" "─" "╰" "│"    ]
  ;;  1 2 3 4 5 6 7 8
  ;;
  (local border [])
  (fn grab [i j]
    (tset border j (. pretty i)))
  (grab 1 1)
  (grab 2 2)
  (grab 3 3)
  (grab 4 8)
  (grab 5 4)
  (grab 6 7)
  (grab 7 6)
  (grab 8 5)
  border)

(fn config []
  (let [cmp     (require :cmp)
        luasnip (require :luasnip)]
    ;; (fn esc [str]
    ;;   (vim.api.nvim_replace_termcodes str true true true))
    ;; (fn check-back-space []
    ;;   (let [col (- (vim.fn.col ".") 1)]
    ;;     (or (= col 0)
    ;;         (-m> (vim.fn.getline ".")
    ;;              [:sub col col]
    ;;              [:match "%s"]))))
    (local
      opt
      {:mapping
         {:<Tab>      (cmp.mapping
                        (fn [fallback]
                          (if (cmp.visible)
                              (cmp.select_next_item)
                              (luasnip.jumpable)
                              (luasnip.jump 1)
                              ;; (vim.snippet.jumpable 1)
                              ;; (luasnip.expand_or_locally_jumpable)
                              ;; (luasnip.expand_or_jump)
                              ;; (check-back-space)
                              ;; (vim.fn.feedkeys (esc :<Tab>) :n)
                              ;; else
                              (fallback)))
                        [:i :s :c])
           :<S-Tab>   (cmp.mapping
                        (fn [fallback]
                          (if (cmp.visible)
                              (cmp.select_prev_item)
                              (luasnip.jumpable -1)
                              ;; (vim.snippet.jumpable -1)
                              ;; else
                              (fallback)))
                        [:i :s :c])
           :<CR>      (cmp.mapping
                        {:i (cmp.mapping.confirm
                              {:behavior cmp.ConfirmBehavior.Insert
                               :select   true})
                         :c (cmp.mapping.confirm
                              {:select   false})})
           :<C-n>     (cmp.mapping
                        (cmp.mapping.select_next_item)
                        [:i :c])
           :<C-p>     (cmp.mapping
                        (cmp.mapping.select_prev_item)
                        [:i :c])
           :<C-d>     (cmp.mapping
                        (cmp.mapping.scroll_docs -4)
                        [:i :c])
           :<C-f>     (cmp.mapping
                        (cmp.mapping.scroll_docs 4)
                        [:i :c])
           :<C-e>     (cmp.mapping
                        (let [beh (fn [fallback]
                                    (if (cmp.visible)
                                        (cmp.abort)
                                        (luasnip.choice_active)
                                        (luasnip.change_choice 1)
                                        ;; else
                                        (fallback)))]
                          {:i beh
                           :s beh
                           :c (cmp.mapping.close)}))
           :<C-y>     (cmp.mapping.confirm
                        {:behavior cmp.ConfirmBehavior.Insert
                         :select   true})
           :<C-Space> (cmp.mapping.complete)}
       ;; :enabled
       ;;   (fn []
       ;;     ;; disable completion in comments
       ;;     (let [context cmp.config.context]
       ;;       (and (not (context.in_treesitter_capture :comment))
       ;;            (not (context.in_syntax_group :Comment)))))
       ;; :event
       ;;   {:on_confirm_done
       ;;     ((. (require :nvim-autopairs.completion.cmp)
       ;;         :on_confirm_done)
       ;;      {:filetypes
       ;;        {:tex false}})}
       :completion
         {:completeopt "menuone,preview,noinsert,noselect"}
       :experimental
         {:native_menu false
          :ghost_text  true}
       :window
         {:documentation
            {:border
               (reorder-border
                 ["╭" "─" "╮"
                  "│"     "│"
                  "╰" "─" "╯"])}}
       :snippet
         {:expand
            (fn [args]
              ;; (vim.snippet.expand args.body))}
              (luasnip.lsp_expand args.body))}
       :formatting
         {:format
            (fn [entry vim-item]
              ;; NOTE: Fancy icons and a name of kind
              (tset
                vim-item
                :kind
                (.. (or (match vim-item.kind
                          :Class         "󰌗 "
                          :Color         " "
                          :Constant      "󰞂 "
                          :Constructor   " "
                          :Enum          "󰕘"
                          :EnumMember    " "
                          :Event         " "
                          :Field         " "
                          :File          "󰈙 "
                          :Folder        "󰉋 "
                          :Function      "󰊕 "
                          :Interface     "󰜰 "
                          :Keyword       "󰌋 "
                          :Method        " "
                          :Module        "󰅩 "
                          :Operator      "󰆕 "
                          :Property      " "
                          :Reference     "󰈝 "
                          :Snippet       " "
                          :Struct        " "
                          :Text          "󰉿 "
                          :TypeParameter "󰊄 "
                          :Unit          "󰑭"
                          :Value         "󰎠 "
                          :Variable      "󰆧 ")
                        "?")
                    " "
                    vim-item.kind))

              ;; NOTE: Set a name for each source
              (tset
                vim-item
                :menu
                (case entry.source.name
                  :path          "[Path]"
                  :calc          "[Calc]"
                  :spell         "[Spell]"
                  :buffer        "[Buffer]"
                  :nvim_lua      "[Lua]"
                  :nvim_lsp      "[LSP]"
                  :luasnip       "[LuaSnip]"
                  :tmux          "[Tmux]"
                  :latex_symbols "[LaTeX]"
                  :crates        "[Crates]"
                  :neorg         "[Neorg]"
                  :conjure       "[Conjure]"
                  :git           "[Git]"
                  name           (as-> $ name
                                    (string.gsub $ "^%l" string.upper)
                                    (string.format $ "[%s]"))))

              ;; NOTE: Allow duplicates for certain sources
              (tset
                vim-item
                :dup
                (match entry.source.name
                  :buffer   1
                  :path     1
                  :nvim_lsp 0
                  :luasnip  1))

              ;; NOTE: Return the updated vim-item
              vim-item)}
       :sources
         [{:name "nvim_lsp"}
          {:name "luasnip"}
          {:name "buffer"
           :option
             {:get_bufnrs
               (fn []
                 ;; All buffers
                 ;; (vim.api.nvim_list_bufs)
                 ;; Buffers in current window
                 (-> (vim.api.nvim_list_wins)
                     vim.iter
                     (: :map vim.api.nvim_win_get_buf)
                     (: :totable)))}}
          ;; {:name "copilot"}
          {:name "nvim_lua"}
          {:name "path"}
          {:name "calc"}
          {:name "latex_symbols"
           :option {:strategy 0}}
          {:name "spell"}
          {:name "conjure"}
          {:name "tmux"
           :option {:all_panes false}}
          {:name "crates"}
          {:name "neorg"}
          {:name "omni"}]})
       ;; :sorting
       ;;   {:comparators
       ;;      [(fn [...]
       ;;         (cmp_buffer:compare_locality ...))]}})))

    (tset vim.o :omnifunc "syntaxcomplete#Complete")

    ;; Use buffer source for `/`
    (cmp.setup.cmdline
      "/"
      {:sources
         {:name "buffer"}})

    ;; Use buffer source for `?`
    (cmp.setup.cmdline
      "?"
      {:sources
         {:name "buffer"}})

    ;; Use cmdline && path source for `:`
    (cmp.setup.cmdline
      ":"
      {:sources
         (cmp.config.sources
           [{:name "cmdline"}])})

    ;; Do not insert latex symbols in tex, only autocomplete them
    (cmp.setup.filetype
      "tex"
      {:sources
         (cmp.config.sources
           [{:name "nvim_lsp"}
            {:name "luasnip"}
            {:name "buffer"
             :option
               {:get_bufnrs
                 ;; All buffers
                 ;; #(vim.api.nvim_list_bufs)
                 #(icollect [_ win (ipairs (vim.api.nvim_list_wins))]
                    (vim.api.nvim_win_get_buf win))}}
            {:name "nvim_lua"}
            {:name "path"}
            {:name "calc"}
            {:name "latex_symbols"
            ;; NOTE:          V V
             :option {:strategy 2}}
            {:name "spell"}
            {:name "tmux"
             :option {:all_panes false}}
            {:name "crates"}
            {:name "neorg"}
            {:name "omni"}])})

    ;; Use appropriate sources for `gitcommit`
    (cmp.setup.filetype
      "gitcommit"
      {:sources
         (cmp.config.sources
           [{:name "git"}
            {:name "cmdline"}
            {:name "nvim_lsp"}
            {:name "nvim_lua"}
            {:name "nvim_lsp_document_symbol"}
            {:name "buffer"}
            {:name "dictionary"}
            {:name "spell"}
            {:name "path"}])})

    (cmp.setup.filetype
      :rust
      {:sorting
         {:priority_weight 2
          :comparators
            (let [compare (require :cmp.config.compare)
                  cmp-rust (require :cmp-rust)]
              [;; deprioritize `.box`, `.mut`, etc.
               cmp-rust.deprioritize_postfix
               ;; deprioritize `Borrow::borrow` and `BorrowMut::borrow_mut`
               cmp-rust.deprioritize_borrow
               ;; deprioritize `Deref::deref` and `DerefMut::deref_mut`
               cmp-rust.deprioritize_deref
               ;; deprioritize `Into::into`, `Clone::clone`, etc.
               cmp-rust.deprioritize_common_traits
               compare.offset
               compare.exact
               compare.score
               compare.recently_used
               compare.locality
               compare.sort_text
               compare.length
               compare.order])}})
    (cmp.setup opt)))

(fn cmp-git-config []
  (let [cmp-git (require :cmp_git)
        format (require :cmp_git.format)
        sort (require :cmp_git.sort)
        opt {;; defaults
             :filetypes ["gitcommit" "NeogitCommitMessage" "octo"]
             ;; in order of most to least prioritized
             :remotes ["upstream" "origin"]
             ;; enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
             :enableRemoteUrlRewrites false
             :git
               {:commits
                  {:limit 100
                   :sort_by sort.git.commits
                   :format format.git.commits}}
             :github
               {;; list of private instances of github
                :hosts {}
                :issues
                  {:fields ["title" "number" "body" "updatedAt" "state"]
                   ;; assigned, created, mentioned, subscribed, all, repos
                   :filter "all"
                   :limit 100
                   ;; open, closed, all
                   :state "open"
                   :sort_by sort.github.issues
                   :format format.github.issues}
                :mentions
                  {:limit 100
                   :sort_by sort.github.mentions
                   :format format.github.mentions}
                :pull_requests
                  {:fields ["title" "number" "body" "updatedAt" "state"]
                   :limit 100
                   ;; open, closed, merged, all
                   :state "open"
                   :sort_by sort.github.pull_requests
                   :format format.github.pull_requests}}
             :gitlab
               {;; list of private instances of gitlab
                :hosts {}
                :issues
                  {:limit 100
                   ;; opened, closed, all
                   :state "opened"
                   :sort_by sort.gitlab.issues
                   :format format.gitlab.issues}
                :mentions
                  {:limit 100
                   :sort_by sort.gitlab.mentions
                   :format format.gitlab.mentions}
                :merge_requests
                  {:limit 100
                   ;; opened, closed, locked, merged
                   :state "opened"
                   :sort_by sort.gitlab.merge_requests
                   :format format.gitlab.merge_requests}}
             :trigger_actions
               [{:debug_name "git_commits"
                 :trigger_character ":"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.git:get-commits callback params trigger-char))}
                {:debug_name "gitlab_issues"
                 :trigger_character "#"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.gitlab:get-issues callback git-info trigger-char))}
                {:debug_name "gitlab_mentions"
                 :trigger_character "@"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.gitlab:get-mentions callback git-info trigger-char))}
                {:debug_name "gitlab_mrs"
                 :trigger_character "!"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.gitlab:get-merge-requests callback git-info trigger-char))}
                {:debug_name "github_issues_and_pr"
                 :trigger_character "#"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.github:get-issues-and-prs callback git-info trigger-char))}
                {:debug_name "github_mentions"
                 :trigger_character "@"
                 :action (fn [sources trigger-char callback params git-info]
                           (sources.github:get-mentions callback git-info trigger-char))}]}]
    (cmp-git.setup opt)))

{1 :hrsh7th/nvim-cmp
 :dependencies [:nvim-treesitter/nvim-treesitter
                :altermo/ultimate-autopair.nvim
                :hrsh7th/cmp-nvim-lsp
                :saadparwaiz1/cmp_luasnip
                :hrsh7th/cmp-buffer
                :hrsh7th/cmp-nvim-lua
                :hrsh7th/cmp-path
                :hrsh7th/cmp-calc
                :f3fora/cmp-spell
                :andersevenrud/cmp-tmux
                :hrsh7th/cmp-cmdline
                :hrsh7th/cmp-omni
                :kdheepak/cmp-latex-symbols
                :ryo33/nvim-cmp-rust
                {1 :petertriho/cmp-git
                 :config cmp-git-config}]
 :event        [:InsertEnter
                :CmdlineEnter]
 : config}
; {1 :zbirenbaum/copilot.lua
;  :cmd :Copilot
;  :event :InsertEnter
;  :config (rv :copilot)}
; {1 :zbirenbaum/copilot-cmp
;  :config (rv :copilot.cmp)}
