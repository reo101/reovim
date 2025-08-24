(fn after []
  (let [plugin (require :plugin)
        dk (require :def-keymaps)
        opt {}]
    (plugin.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/user/repo"
 :data {: after
        :enabled false}}
