(fn config []
  (let [stay-in-place (require :stay-in-place)
        opt {:set_keymaps true
             :setpreserve_visual_selection true}]
    (stay-in-place.setup opt)))

{1 :gbprod/stay-in-place.nvim
 :event :VeryLazy
 : config}
