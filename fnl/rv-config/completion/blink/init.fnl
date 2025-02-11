(fn config []
  (let [blink-cmp (require :blink-cmp)
        dk (require :def-keymaps)
        opt {:completion
              {:accept
                {:auto_brackets {:enabled false}}
               :list
                {:selection
                  {:preselect
                    (fn [ctx]
                      (and (= ctx.mode :cmdline)
                           (not (blink-cmp.snippet_active {:direction 1}))))
                   :auto_insert
                    (fn [ctx]
                      (not= ctx.mode :cmdline))}}
               :menu
                {:draw
                  {:columns
                    [{1 :kind_icon}
                     {1 :label :gap 1}]
                   :components
                    {:label
                      (let [colorful-menu (require :colorful-menu)]
                        {:text colorful-menu.blink_components_text
                         :highlight colorful-menu.blink_components_highlight})}}}
               :documentation
                {:auto_show true
                 :auto_show_delay_ms 500}
               :ghost_text
                {:enabled true}}
             :snippets
              {:preset :luasnip}
             :sources
              {:default
                (fn [ctx]
                  (local (success node) (pcall vim.treesitter.get_node))
                  (if (= vim.bo.filetype :lua)
                      [:lsp :path]
                      (and success
                           node
                           (vim.tbl_contains
                             [:comment
                              :line_comment
                              :block_comment]
                             (node:type)))
                      [:buffer]
                      ;; else
                      [:lsp :path :snippets :buffer]))
               :min_keyword_length
                #(if (= vim.bo.filetype :markdown) 2 0)
               :providers
                {:latex
                  {:name :latex_symbols
                   :module :blink.compat.source}
                 :ecolog
                  {:name :ecolog
                   :module :ecolog.integrations.cmp.blink_cmp}
                 :crates
                  {:name :crates
                   :module :blink.compat.source}
                 :tmux
                  {:name :tmux
                   :module :blink.compat.source
                   :opts {:all_panes false}}
                 :conjure
                  {:name :conjure
                   :module :blink.compat.source}
                 :dadbod
                  {:name :Dadbod
                   :module :vim_dadbod_completion.blink}
                 :agda
                  {:name :agda
                   :module :blink.compat.source}
                 :digraphs
                  {:name :digraphs
                   :module :blink.compat.source
                   :opts {:cache_digraphs_on_start true}
                   :score_offset (- 3)}}}
             :signature
              {:enabled true}}]
    (blink-cmp.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

[{1 :saghen/blink.compat
  :version "*"
  :lazy true
  :opts {}}
 {1 :saghen/blink.cmp
  :version :0.*
  :dependencies [:dmitmel/cmp-digraphs
                 :hrsh7th/cmp-calc
                 ;; :f3fora/cmp-spell
                 :andersevenrud/cmp-tmux
                 ;; :hrsh7th/cmp-cmdline
                 ;; :hrsh7th/cmp-omni
                 :kdheepak/cmp-latex-symbols
                 :ryo33/nvim-cmp-rust
                 :philosofonusus/ecolog.nvim
                 {1 :L3MON4D3/LuaSnip :version :v2.*}
                 ;; NOTE: configured in ../colorful-menu
                 :xzbdmw/colorful-menu.nvim]
  : config}]
