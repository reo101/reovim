(fn after []
  (let [amp (require :amp)
        dk (require :def-keymaps)
        opt {:auto_start true
             :log_level :info}]
    (amp.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/sourcegraph/amp.nvim"
 :data {:event :DeferredUIEnter
        : after}}
