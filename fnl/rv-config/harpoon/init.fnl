(fn config []
  (let [harpoon (require :harpoon)
        dk (require :def-keymaps)
        opt {}]
    (harpoon.setup opt)

    (dk :n
        {:h {:name :Harpoon
             :hydra
               {:p [#(-> harpoon (: :list) (: :prev)) :Prev]
                :n [#(-> harpoon (: :list) (: :next)) :Next]}
             :a [#(-> harpoon (: :list) (: :append)) :Append]
             :e [#(harpoon.ui:toggle_quick_menu (harpoon:list)) :Edit]
             :1 [#(-> harpoon (: :list) (: :select 1)) :1]
             :2 [#(-> harpoon (: :list) (: :select 2)) :2]
             :3 [#(-> harpoon (: :list) (: :select 3)) :3]}}
        {:prefix :<leader>})))

{1 :ThePrimeagen/harpoon
 :branch :harpoon2
 :keys [{1 :<leader>h :desc :Harpoon}]
 : config}
