(fn after []
  (let [sidekick (require :sidekick)
        sidekick-cli (require :sidekick.cli)
        dk (require :def-keymaps)
        opt {:nes {:enabled true}
             :cli {:mux {:backend :zellij
                         :enabled true}}}]
    (sidekick.setup opt)

    (comment
      (do
        (local sidekick (require :sidekick))
        (local sidekick-cli (require :sidekick.cli))
        (local dk (require :def-keymaps))))

    ;; Non-prefixed keys
    (dk
      {:<c-.> [#(sidekick-cli.focus) "Sidekick Switch Focus" [:n :x :i :t]]
       :<tab> [#(when (not (sidekick.nes_jump_or_apply)) :<Tab>)
               "Goto/Apply Next Edit Suggestion"
               :n
               {:expr true}]})

       ;; Leader-prefixed group
    (dk
      {:a {:group "Sidekick AI"
           :s [[#(sidekick-cli.select) "Sidekick Select CLI" :n]
               [#(sidekick-cli.send {:selection true}) "Sidekick Send Visual Selection" :v]]
           :a [#(sidekick-cli.toggle) "Sidekick Toggle CLI" [:n :v]]
           :c [#(sidekick-cli.toggle {:focus true :name :claude}) "Sidekick Claude Toggle" [:n :v]]
           :p [#(sidekick-cli.prompt) "Sidekick Select Prompt" [:n :v]]}}
      {:prefix :<leader>})))

{:src "https://github.com/folke/sidekick.nvim"
 :data {: after}}
