(fn after []
   (let [rustowl (require :rustowl)
         dk (require :def-keymaps)
         opt {:client
                {:on_attach
                  (fn [_ bufnr]
                    (dk :n
                        {:l {:group :LSP
                             :o [#(rustowl.toggle bufnr) "Toggle RustOwl"]}}
                        {:prefix :<leader>}))}}]
     (rustowl.setup opt)))

{:src "https://github.com/cordx56/rustowl"
 :version :v0.3.4
 :data {;; :ft [:rust]
        : after
        :enabled (= (vim.fn.executable :rustowl) 1)}}
