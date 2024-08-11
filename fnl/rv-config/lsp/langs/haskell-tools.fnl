(fn config []
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
                :capabilities lsp-capabilities}
             :dap {}}]
    (tset vim.g :haskell_tools opt)))

{1 :MrcJkb/haskell-tools.nvim
 :version :^4
 : config}
