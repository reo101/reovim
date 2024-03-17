(import-macros
  {: dbg!}
  :init-macros)

(fn config []
  (let [dk (require :def-keymaps)
        opt {:autopairs {:enable true}
             :query_linter {:use_virtual_text true
                            :enable true
                            :lint_events [:BufWrite
                                          :CursorHold]}
             :autotag {:enable true
                       :filetypes [:html
                                   :javascriptreact
                                   :typescriptreact
                                   :markdown
                                   :svelte
                                   :vue
                                   :xml]
                       :skip_tags [:area
                                   :base
                                   :br
                                   :col
                                   :command
                                   :embed
                                   :hr
                                   :img
                                   :input
                                   :keygen
                                   :link
                                   :menuitem
                                   :meta
                                   :param
                                   :slot
                                   :source
                                   :track
                                   :wbr]}
             :indent {:enable true}
             :textsubjects {:enable true
                            :prev_selection ","
                            :keymaps {";"  :textsubjects-container-outer
                                      "."  :textsubjects-smart
                                      "i;" :textsubjects-container-inner}}
             :incremental_selection {:keymaps {:init_selection    :<leader>siv
                                               :node_decremental  :<leader>sid
                                               :node_incremental  :<leader>sii
                                               :scope_incremental :<leader>sis}
                                     :enable true}
             ;; :context_commentstring {:enable true
             ;;                         :enable_autocmd false}
             :refactor {:navigation {:enable true
                                     :keymaps {:list_definitions :<leader>sdl
                                               :goto_definition  :<leader>sdg}}
                        :highlight_definitions {:enable true}
                        :smart_rename { :enable true
                                       :keymaps {:smart_rename :<leader>sr}}}
             :context {:enable true}
             :textobjects {:enable true
                           :swap {:enable true
                                  :swap_previous {:<leader>sspp "@parameter.inner"
                                                  :<leader>sspf "@function.outer"
                                                  :<leader>sspc "@class.outer"}
                                  :swap_next {:<leader>ssnc "@class.outer"
                                              :<leader>ssnp "@parameter.inner"
                                              :<leader>ssnf "@function.outer"}}
                           :lsp_interop {:enable false}
                           :move {:enable true
                                  :set_jumps true
                                  :goto_next_start {"]m" "@function.outer"
                                                    "]]" "@class.outer"}
                                  :goto_next_end   {"][" "@class.outer"
                                                    "]M" "@function.outer"}
                                  :goto_previous_start {"[[" "@class.outer"
                                                        "[m" "@function.outer"}
                                  :goto_previous_end   {"[M" "@function.outer"
                                                        "[]" "@class.outer"}}
                           :select {:lookahead true
                                    :enable true
                                    :keymaps {:ir "@parameter.inner"
                                              :im "@call.inner"
                                              :ad "@comment.outer"
                                              :aC "@class.outer"
                                              :af "@function.outer"
                                              :ar "@parameter.outer"
                                              :ie "@block.inner"
                                              :is "@statement.inner"
                                              :ic "@conditional.inner"
                                              :am "@call.outer"
                                              :al "@loop.outer"
                                              :ac "@conditional.outer"
                                              :il "@loop.inner"
                                              :iC "@class.inner"
                                              :ae "@block.outer"
                                              :if "@function.inner"
                                              :as "@statement.outer"}
                                    :selection_modes {"@parameter.outer" :v
                                                      "@function.outer"  :V}}
                           :disable {}}
             :highlight {:enable true
                         :additional_vim_regex_highlighting ["circom"]}
             :playground {:updatetime 25
                          :enable true
                          :disable {}
                          :keybindings {:update                    :R
                                        :goto_node                 :<CR>
                                        :show_help                 :?
                                        :focus_language            :f
                                        :toggle_hl_groups          :i
                                        :toggle_language_display   :I
                                        :toggle_anonymous_nodes    :a
                                        :toggle_injected_languages :t
                                        :unfocus_language          :F
                                        :toggle_query_editor       :o}
                          :persist_queries false}}]
    ;; ((. (require :rv-config.treesitter.context) :config))
    (vim.api.nvim_create_user_command
      :TSFullNodeUnderCursor
      #((. (require :nvim-treesitter-playground.hl-info
             :show_ts_node)
          {:full_path true
           :show_range false
           :include_anonymous true
           :highlight_node true}))
      {})
    ;; (#setgsub! conceal @conceal "ab(.)" "%1")
    (vim.treesitter.query.add_directive
      :setgsub!
      (fn [matches _ts-pattern bufnr list metadata]
        (let [[_directive key capture_id pattern replacement]
              list]
          (tset metadata
                key
                (string.gsub
                  (vim.treesitter.get_node_text
                    (. matches capture_id)
                    bufnr
                    {:metadata (. metadata capture_id)})
                  pattern
                  replacement))))
      true)
    (vim.treesitter.query.add_predicate
      :has-no-child?
      (fn [matches _ts-pattern bufnr pred]
        (let [[_directive capture_id & not-wanted] pred
              [node] (. matches capture_id)]
          (not
            (faccumulate [any false
                          i 0 (- (node:child_count) 1)]
              (let [child (node:child i)
                    child-text (vim.treesitter.get_node_text
                                  child
                                  bufnr)]
                (or any (vim.tbl_contains not-wanted child-text)))))))
      {:all true})

    ;; NOTE: way need to swap around to compile all parsers
    (tset (require :nvim-treesitter.install)
          :compilers
          [:clang
           "zig cc"
           :gcc])

    (vim.tbl_extend :force
      ((. (require :nvim-treesitter.parsers) :get_parser_configs))
      {:typst
        {:install_info {:url    "https://github.com/frozolotl/tree-sitter-typst"
                        :files  [:src/parser.c
                                 :src/scanner.cc]
                        :branch :master}
         :filetype :typst}
       ;; :typescript
       ;;  {:install_info {:url    "https://github.com/tree-sitter/tree-sitter-typescript"
       ;;                  :files  [:tsx/src/parser.c
       ;;                           :tsx/src/scanner.c]
       ;;                  :branch :master}}
       :noir
        {:install_info {:url    "https://github.com/hhamud/tree-sitter-noir"
                        :files  [:src/parser.c
                                 :src/scanner.c]
                        :branch :main}
         :filetype :noir}
       ;; NOTE: was using a PR
       ;; :scala
       ;;  {:install_info {:url    "https://github.com/eed3si9n/tree-sitter-scala"
       ;;                  :files  [:src/parser.c
       ;;                           :src/scanner.c]
       ;;                  :branch :fork-integration
       ;;                  :requires_generate_from_grammar false}}
       :crisp
        {:install_info {:url    "https://github.com/reo101/tree-sitter-crisp"
                        :files  [:src/parser.c]
                        :branch :master}}
       :xml
        {:install_info {:url    "https://github.com/dorgnarg/tree-sitter-xml"
                        :files  [:src/parser.c]
                        :branch :main
                        :requires_generate_from_grammar true}}
       :http
        {:install_info {:url    "https://github.com/NTBBloodbath/tree-sitter-http"
                        :files  [:src/parser.c]
                        :branch :main}}
       :norg_meta
        {:install_info {:url    "https://github.com/nvim-neorg/tree-sitter-norg-meta"
                        :files  [:src/parser.c]
                        :branch :main}}
       :norg_table
        {:install_info {:url    "https://github.com/nvim-neorg/tree-sitter-norg-table"
                        :files  [:src/parser.c]
                        :branch :main}}
       :brainfuck
        {:install_info {:url    "https://github.com/reo101/tree-sitter-brainfuck"
                        :files  [:src/parser.c]
                        :branch :master}}
       :awk
        {:install_info {:url    "https://github.com/Beaglefoot/tree-sitter-awk"
                        :files  [:src/parser.c
                                 :src/scanner.c]
                        :branch :master}}
       :odin
        {:install_info {:url "https://github.com/MineBill/tree-sitter-odin"
                        :files [:src/parser.c]
                        :branch :master}}
       :nu
        {:install_info {:url    "https://github.com/nushell/tree-sitter-nu"
                        :files  [:src/parser.c]
                        :branch :main}}})
    ((. (require :nvim-treesitter.configs) :setup) opt)

    (local mappings
           {:t {:s {:h ["<Cmd>TSBufToggle highlight<CR>"
                        :Highlighting]
                    ;; :c [(. (require :treesitter-context)
                    ;;        :toggleEnabled)
                    ;;     :Context]
                    :g [:<Cmd>TSPlaygroundToggle<CR>
                        :PlayGround]
                    :t ["<Cmd>TSBufToggle autotag<CR>"
                        :Autotags]
                    :p ["<Cmd>TSBufToggle autopairs<CR>"
                        :Autopairs]
                    :name :TreeSitter}
                :name :Toggle}
            :s {:d {:g ["Goto definition"]
                    :l ["List definitions"]
                    :name :Definitions}
                :r ["Smart rename"]
                :i {:d ["Node Decremental"]
                    :s ["Scope Incremental"]
                    :i ["Node Incremental"]
                    :v ["Init selection"]
                    :name "Incremental Selection"}
                :s {:p {:p [:Parameter]
                        :c [:Class]
                        :f [:Function]
                        :name "Swap previous"}
                    :name :Swap
                    :n {:p [:Parameter]
                        :c [:Class]
                        :f [:Function]
                        :name "Swap next"}}
                :name :TreeSitter}})
    (dk :n mappings {:prefix :<leader>})
    (local operator-mappings
           {:i {:name :inside
                :C  ["@class.inner"]
                :c  ["@conditional.inner"]
                :e  ["@block.inner"]
                :f  ["@function.inner"]
                :l  ["@loop.inner"]
                :m  ["@call.inner"]
                :r  ["@parameter.inner"]
                :s  ["@statement.inner"]}
            :a {:name :around
                :C  ["@class.outer"]
                :c  ["@conditional.outer"]
                :d  ["@comment.outer"]
                :e  ["@block.outer"]
                :f  ["@function.outer"]
                :l  ["@loop.outer"]
                :m  ["@call.outer"]
                :r  ["@parameter.outer"]
                :s  ["@statement.outer"]}
            ";"  ["textsubjects-container-outer"]
            "i;" ["textsubjects-container-inner"]
            ","  ["textsubjects-last"]
            "."  ["textsubjects-smart"]})
    (dk :o operator-mappings {:noremap false})
    (local motion-mappings
           {"][" ["Next @class.outer end"]
            "[]" ["Previous @class.outer end"]
            "]m" ["Next @function.outer start"]
            "[M" ["Previous @function.outer end"]
            "]]" ["Next @class.outer start"]
            "[[" ["Previous @class.outer start"]
            "]M" ["Next @function.outer end"]
            "[m" ["Previous @function.outer start"]})
    (dk [:n :o] motion-mappings {:noremap false})))

[{1       :nvim-treesitter/nvim-treesitter
  : config}
 (require (.. ... :.rainbow))
 (let [treesitter-plugins
        [;; :nvim-treesitter/nvim-treesitter-textobjects
         :mfussenegger/nvim-ts-hint-textobject
         :nvim-treesitter/playground
         ;; :romgrk/nvim-treesitter-context
         :JoosepAlviste/nvim-ts-context-commentstring
         :windwp/nvim-ts-autotag]
           ;; :RRethy/nvim-treesitter-textsubjects]
       convert-to-treesitter-opt
        (fn [treesitter-plugin]
          {1             treesitter-plugin
           :dependencies [:nvim-treesitter/nvim-treesitter]})]
   (vim.tbl_map
     convert-to-treesitter-opt
     treesitter-plugins))]
