(fn config []
  (let [devicons (require :nvim-web-devicons)
        opt {;; your personnal icons can go here (to override)
             ;; DevIcon will be appended to `name`
             :override
               {:zsh {:icon ""
                      :color "#428850"
                      :name :Zsh}}

             ;; globally enable default icons (default to false)
             ;; will get overriden by `get_icons` option
             :default true}]
    (devicons.setup opt)))

{1 :nvim-tree/nvim-web-devicons
 :event :VeryLazy
 : config}
