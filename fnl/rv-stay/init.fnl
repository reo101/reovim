(fn config []
  (let [opt {:set_keymaps true
             :setpreserve_visual_selection true}]
    ((. (require :stay-in-place) :setup) opt)))

{: config}
