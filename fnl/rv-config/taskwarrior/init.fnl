(fn after []
  (let [taskwarrior (require :taskwarrior)
        dk (require :def-keymaps)
        opt {}]
    (taskwarrior.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/matthandzel/taskwarrior.nvim"
 :data {:enabled false
        : after}}
