(fn config []
  (let [harpoon (require :harpoon)
        dk (require :def-keymaps)
        opt {}]
    (harpoon.setup opt)

    ;; TODO: (def-keymaps) let `hydra take a map of keybinds`
    (dk [:n]
        {:h {:name :Harpoon
             :hydra true
             :p [#(-> harpoon (: :list) (: :prev)) :Prev]
             :n [#(-> harpoon (: :list) (: :next)) :Next]}}
        {:prefix :<leader>})
    (dk [:n]
        {:h {:name :Harpoon
             :a [#(-> harpoon (: :list) (: :append)) :Append]
             :e [#(harpoon.ui:toggle_quick_menu (harpoon:list)) :Edit]
             :1 [#(-> harpoon (: :list) (: :select 1)) :1]
             :2 [#(-> harpoon (: :list) (: :select 2)) :2]
             :3 [#(-> harpoon (: :list) (: :select 3)) :3]}}
        {:prefix :<leader>})))

{1 :ThePrimeagen/harpoon
 :branch :harpoon2
 : config}
