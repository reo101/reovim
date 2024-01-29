(fn config []
  (let [neotest (require :neotest)
        dk (require :def-keymaps)
        opt {:adapters
               [((require :neotest-haskell)
                 {:build_tools [:stack :cabal]
                  :frameworks [:hspec :tasty :sydtest]})
                ((require :neotest-rust)
                 {})
                ((require :neotest-zig)
                 {})
                ((require :neotest-foundry)
                 {})]}]
    (neotest.setup opt)

    (dk [:n]
        {}
        {:prefix :<leader>})))

{: config}
