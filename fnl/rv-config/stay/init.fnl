(fn after []
  (let [stay-in-place (require :stay-in-place)
        opt {:set_keymaps true
             :setpreserve_visual_selection true}]
    (stay-in-place.setup opt)))

{:src "https://github.com/gbprod/stay-in-place.nvim"
 :data {:event :DeferredUIEnter
        : after}}
