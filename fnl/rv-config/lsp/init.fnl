(fn after []
  (let [lspconfig (require :lspconfig)
        utils (require :rv-config.lsp.utils)
        servers [:latex
                 :sqls
                 :zig
                 :tsserver
                 :bash
                 :json
                 :clangd
                 :docker
                 :nim
                 :racket
                 :python
                 ;; :haskell
                 :cmake
                 :emmet-ls
                 :go
                 :erlang
                 :lua
                 :clojure
                 :angular
                 :prolog
                 :terraform
                 :nix
                 :yaml
                 :r
                 :xml
                 :purescript
                 :fennel
                 ;; :solidity
                 :php
                 :ocaml
                 :pest
                 :circom
                 :noir
                 ;; :omnisharp
                 :solang
                 ;; :agda
                 :wgsl
                 :typst]]

    (each [_ name (ipairs servers)]
      ;; All defined in `../../../lsp/${name}.json`
      (vim.lsp.enable name))

    (vim.lsp.config
      "*"
      {:flags {:debounce_text_changes 150}
       :on_init utils.lsp-on-init
       :on_attach utils.lsp-on-attach
       :capabilities utils.lsp-capabilities})

    (utils.lsp-override-handlers)))

[{:src "https://github.com/neovim/nvim-lspconfig"
  :data {:event :BufRead
         : after}}
 #_(require (.. ... :.lines))
 (require (.. ... :.diagnostics))
 ;; TODO: spearate out in different directory?
 (icollect [_ lang-plugin
              (ipairs [:rustaceanvim
                       :haskell-tools
                       :lean
                       :idris2
                       :agda
                       :metals
                       :nvim-java
                       :texmagic
                       #_:dotnvim
                       :roslyn])]
   (require (.. ... :.langs. lang-plugin)))
 {:src "https://github.com/b0o/schemastore.nvim"}]
