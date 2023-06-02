(fn config []
  (let [opt {:autopairs {:enable true}
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
             :context_commentstring {:enable true
                                     :enable_autocmd false}
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
             :highlight {:enable true}
             :rainbow {:extended_mode true
                       :enable true
                       :max_file_lines nil}
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
    (vim.api.nvim_create_user_command :TSFullNodeUnderCursor
                                      (fn []
                                        ((. (require :nvim-treesitter-playground.hl-info)
                                            :show_ts_node) {:full_path true
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
    (tset (require :nvim-treesitter.install) :compilers  ["zig cc" :clang :gcc])
    ;; (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
    ;;       :typescript
    ;;       {:install_info {:url    "https://github.com/tree-sitter/tree-sitter-typescript"
    ;;                       :files  [:tsx/src/parser.c
    ;;                                :tsx/src/scanner.c]
    ;;                       :branch :master}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :scala
          {:install_info {:url    "https://github.com/eed3si9n/tree-sitter-scala"
                          :files  [:src/parser.c :src/scanner.c]
                          :branch :fork-integration
                          :requires_generate_from_grammar false}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :crisp
          {:install_info {:url    "https://github.com/reo101/tree-sitter-crisp"
                          :files  [:src/parser.c]
                          :branch :master}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :xml
          {:install_info {:url    "https://github.com/dorgnarg/tree-sitter-xml"
                          :files  [:src/parser.c]
                          :branch :main
                          :requires_generate_from_grammar true}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :http
          {:install_info {:url    "https://github.com/NTBBloodbath/tree-sitter-http"
                          :files  [:src/parser.c]
                          :branch :main}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :norg_meta
          {:install_info {:url    "https://github.com/nvim-neorg/tree-sitter-norg-meta"
                          :files  [:src/parser.c]
                          :branch :main}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :norg_table
          {:install_info {:url    "https://github.com/nvim-neorg/tree-sitter-norg-table"
                          :files  [:src/parser.c]
                          :branch :main}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :brainfuck
          {:install_info {:url    "https://github.com/reo101/tree-sitter-brainfuck"
                          :files  [:src/parser.c]
                          :branch :master}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :awk {:install_info {:url    "https://github.com/Beaglefoot/tree-sitter-awk"
                               :files  [:src/parser.c
                                        :src/scanner.c]
                               :branch :master}})
    (tset ((. (require :nvim-treesitter.parsers) :get_parser_configs))
          :odin
          {:install_info {:url "https://github.com/MineBill/tree-sitter-odin"
                          :files [:src/parser.c]
                          :branch :master}})
    ((. (require :nvim-treesitter.configs) :setup) opt)
    (local wk (require :which-key))
    (local mappings {:t {:s {:h ["<Cmd>TSBufToggle highlight<CR>"
                                 :Highlighting]
                             ;; :c [(. (require :treesitter-context)
                             ;;        :toggleEnabled)
                             ;;     :Context]
                             :g [:<Cmd>TSPlaygroundToggle<CR>
                                 :PlayGround]
                             :r ["<Cmd>TSBufToggle rainbow<CR>"
                                 "Rainbow Parenthesis"]
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
    (wk.register mappings {:prefix :<leader>})
    (local operator-mappings
                 {:ir  ["@parameter.inner"]
                  :im  ["@call.inner"]
                  :ad  ["@comment.outer"]
                  :aC  ["@class.outer"]

                  :i   {:name
                        :inside}
                  :af  ["@function.outer"]
                  :.   ["textsubjects-smart"]
                  :ar  ["@parameter.outer"]
                  :ie  ["@block.inner"]
                  ","  ["textsubjects-last"]
                  :is  ["@statement.inner"]
                  :ic  ["@conditional.inner"]
                  :am  ["@call.outer"]
                  "i;" ["textsubjects-container-inner"]
                  :al  ["@loop.outer"]
                  ";"  ["textsubjects-container-outer"]
                  :ac  ["@conditional.outer"]

                  :a   {:name
                        :around}
                  :il  ["@loop.inner"]
                  :as  ["@statement.outer"]
                  :ae  ["@block.outer"]
                  :if  ["@function.inner"]
                  :iC  ["@class.inner"]})
    (wk.register operator-mappings {:prefix "" :mode :o})
    (local motion-mappings
           {"][" ["Next @class.outer end"]
            "[]" ["Previous @class.outer end"]
            "[M" ["Previous @function.outer end"]
            "[[" ["Previous @class.outer start"]
            "]m" ["Next @function.outer start"]
            "]M" ["Next @function.outer end"]
            "[m" ["Previous @function.outer start"]
            "]]" ["Next @class.outer start"]})
    (wk.register motion-mappings {:prefix "" :mode :n})
    (wk.register motion-mappings {:prefix "" :mode :o})
    (let [{: prequire} (require :globals)
          tsht (prequire :tsht)]
      (when tsht
       (local TSHop-mappings {:m [(. tsht :nodes) "TS Hop"]})
       (wk.register TSHop-mappings {:prefix "" :mode :o})
       (wk.register TSHop-mappings {:prefix "" :noremap true :mode :v})))))

{: config}
