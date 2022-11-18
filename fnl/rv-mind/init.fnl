(fn config []
  (let [dk  (require :def-keymaps)
        mind (require :mind)
        opt nil]
    (dk :n
        {:m {:name :Mind
             :m [#(mind.open_main)    "Main"]
             :p [#(mind.open_project) "Project"]
             :c [#(mind.close)        "Close"]
             :r [#(mind.reload_state) "Reload"]}}
        :<leader>)
    (mind.setup opt)))

{: config}
