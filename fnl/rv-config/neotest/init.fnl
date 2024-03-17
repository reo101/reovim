(fn config []
  (let [neotest (require :neotest)
        neotest-lib (require :neotest.lib)
        dk (require :def-keymaps)
        opt {:adapters
               [((require :neotest-haskell)
                 {:build_tools [:stack :cabal]
                  :frameworks [:hspec :tasty :sydtest]})
                (require :neotest-busted)
                ;; (require :rustaceanvim.neotest)
                ((require :neotest-rust)
                 {})
                ((require :neotest-zig)
                 {})
                ((require :neotest-foundry)
                 {})]
             :consumers
               {:notify
                  (fn [client]
                    ;; (vim.print client.listeners.results)
                    (set client.listeners.results
                         (fn [adapter-id results partial?]
                           ;; (vim.print {: adapter-id
                           ;;             : results
                           ;;             : partial?})
                           (when (not partial?)
                             (neotest-lib.notify "Lesno"))))
                    {})}}]
    (neotest.setup opt)

    (dk [:n]
        {:l {:name :LSP
             :n {:name :Neotest
                 :r {:name :Run
                     :n [#(neotest.run.run) "Nearest test"]
                     :f [#(neotest.run.run (vim.fn.expand :%)) "Whole file"]
                     :s [#(neotest.run.stop) "Stop"]
                     :d [#(neotest.run.attach) "Debug nearest test"]
                     :a [#(neotest.run.attach) "Attach to nearest test"]}
                 :s {:name :Summary
                     :o [#(neotest.summary.open) "Open"]
                     :c [#(neotest.summary.close) "Close"]
                     :t [#(neotest.summary.toggle) "Toggle"]}
                 :q [#(neotest.quickfix) "Send to quickfix"]}}}
        {:prefix :<leader>})
    (dk [:n]
        {"]n" [#(neotest.jump.prev {:status :failed}) "Prev failing test"]
         "[n" [#(neotest.jump.next {:status :failed}) "Next failing test"]}
        {})))

{1 :nvim-neotest/neotest
 :dependencies [:nvim-lua/plenary.nvim
                :mrcjkb/neotest-haskell
                :lawrence-laz/neotest-zig
                :llllvvuu/neotest-foundry
                ;; :mrcjkb/rustaceanvim
                :rouge8/neotest-rust
                :HiPhish/neotest-busted]
 : config}
