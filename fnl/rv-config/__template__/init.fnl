(fn config []
  (let [plugin (require :plugin)
        dk (require :def-keymaps)
        opt {}]
    (plugin.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{1 :user/repo
 : config
 :enabled false}
