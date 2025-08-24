(fn after []
  (let [dk (require :def-keymaps)
        {: lsp-on-attach
         : lsp-capabilities} (require :rv-config.lsp.utils)
        opt {:tools
               {:repl
                  {:handler :toggleterm}}
             :hls
               {:on_attach
                  (fn [client bufnr ht]
                    (lsp-on-attach client bufnr))
                :capabilities lsp-capabilities
                :settings
                  {:haskell {:formattingProvider :fourmolu}}}
             :dap {}}]
    (tset vim.g :haskell_tools opt)))

{:src "https://github.com/MrcJkb/haskell-tools.nvim"
 :data {:version :^4
        : after}}
