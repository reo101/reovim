(fn after []
  (let [fyler (require :fyler)
        dk (require :def-keymaps)
        opt {:integrations {:icon #_:nvim_web_devicons :mini_icons}}]
    (fyler.setup opt)

    (dk :n
        {:t {:group :Toggle
             :f [#(vim.cmd :Fyler) :fyler]}}
        {:prefix :<leader>})))

{:src "https://github.com/A7Lavinraj/fyler.nvim"
 :version "v2.0.0"
 :data {: after}}
