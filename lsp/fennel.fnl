(local
  fennel-language-server
  {:cmd [:fennel-language-server]
   :filetypes [:fennel]
   :settings {:fennel {:diagnostics {:globals [:vim :bit]}
                       :workspace   {:library (vim.api.nvim_list_runtime_paths)}}}
   :root_markers [:*.fnl]
   :single_file_support true})

(local
  fennel-ls
  {:cmd [:fennel-ls]
   :filetypes [:fennel]
   :settings {:fennel-ls
               {:extra-globals
                  (table.concat [:vim])
                :fennel-path
                  (table.concat
                    ["./?.fnl"
                     "./?/init.fnl"
                     "src/?.fnl"
                     "src/?/init.fnl"]
                    ";")
                :macro-path
                  #_(table.concat
                      ["./?.fnl"
                       "./?/init-macros.fnl"
                       "./?/init.fnl"
                       "src/?.fnl"
                       "src/?/init-macros.fnl"
                       "src/?/init.fnl"
                       ;; NOTE: mine
                       (.. (vim.fn.stdpath "config") :/fnl/?.fnl)
                       ;; TODO: different when `nixCats`?
                       (.. (vim.fn.stdpath "data") :/site/pack/core/opt/typed-fennel/fnl/?.fnl)]
                      ";")
                  (-> :fennel require (. :macro-path))}}
   :root_markers [:.git]
   :single_file_support true})

fennel-ls
