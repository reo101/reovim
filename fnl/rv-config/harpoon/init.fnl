(fn after []
  (let [harpoon (require :harpoon)
        dk (require :def-keymaps)
        opt {}]
    (harpoon.setup opt)

    (dk :n
        {:h {:group :Harpoon
             :hydra
               {:p [#(-> harpoon (: :list) (: :prev)) :Prev]
                :n [#(-> harpoon (: :list) (: :next)) :Next]}
             :a [#(-> harpoon (: :list) (: :add)) :Add]
             :h [#(-> harpoon.ui (: :toggle_quick_menu (harpoon:list))) :Edit]
             :1 [#(-> harpoon (: :list) (: :select 1)) :1]
             :2 [#(-> harpoon (: :list) (: :select 2)) :2]
             :3 [#(-> harpoon (: :list) (: :select 3)) :3]}}
        {:prefix :<leader>})))

{:src "https://github.com/ThePrimeagen/harpoon"
 :version :harpoon2
 :data {;; :keys [{:src :<leader>h :desc :Harpoon}]
        : after}}
