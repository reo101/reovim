(fn after []
  (let [dk  (require :def-keymaps)
        mind (require :mind)
        opt nil]
    (dk :n
        {:m {:group :Mind
             :m [#(mind.open_main)    "Main"]
             :p [#(mind.open_project) "Project"]
             :c [#(mind.close)        "Close"]
             :r [#(mind.reload_state) "Reload"]}}
        {:prefix :<leader>})
    (mind.setup opt)))

{:src "https://github.com/Selyss/mind.nvim"
 :version :v2.2
 :data {:dependencies [:nvim-lua/plenary.nvim
                       :nvim-tree/nvim-web-devicons]
        ;; :keys [{:src :<leader>m :desc :Mind}]
        : after}}
