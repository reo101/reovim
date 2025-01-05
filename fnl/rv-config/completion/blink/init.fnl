(fn config []
  (let [blink-cmp (require :blink-cmp)
        dk (require :def-keymaps)
        opt {:sources
              {:default [:lsp :path :snippets :buffer :digraphs]
               :providers
                 {:digraphs
                   {:name :digraphs
                    :module :blink.compat.source
                    :opts {:cache_digraphs_on_start true}
                    :score_offset (- 3)}
                  ;; :latex
                  ;;  {:module :blink.compat.source
                  ;;   :name :latex
                  ;;   :opts {:all_panes false}}
                  :conjure
                   {:name :conjure
                    :module :blink.compat.source}
                  :crates
                   {:name :crates
                    :module :blink.compat.source}
                  :ecolog
                   {:name :ecolog
                    :module :ecolog.integrations.cmp.blink_cmp}
                  :agda
                   {:name :agda
                    :module :blink.compat.source}}}}]
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
                 :saadparwaiz1/cmp_luasnip
                 :hrsh7th/cmp-calc
                 ;; :f3fora/cmp-spell
                 :andersevenrud/cmp-tmux
                 ;; :hrsh7th/cmp-cmdline
                 ;; :hrsh7th/cmp-omni
                 :kdheepak/cmp-latex-symbols
                 :ryo33/nvim-cmp-rust
                 :philosofonusus/ecolog.nvim]
  : config}]
