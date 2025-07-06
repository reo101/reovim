(fn after []
  (let [colorful-menu (require :colorful-menu)
        dk (require :def-keymaps)
        opt {:ls {}
             :fallback_highlight "@variable"
             :max_width 60}]
    (colorful-menu.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/xzbdmw/colorful-menu.nvim"
 :data {:event :DeferredUIEnter
        :opts {}
        :on_require [:colorful-menu]
        : after}}
