(fn config []
   (let [opt {:action_keys {:close_folds [:zM :zm]
                            :open_folds [:zR :zr]
                            :toggle_fold [:zA :za]
                            :jump_close [:o]
                            :preview :p
                            :toggle_preview :P
                            :open_vsplit [:<c-v>]
                            :close :q
                            :refresh :r
                            :previous :k
                            :toggle_mode :m
                            :cancel :<esc>
                            :jump [:<cr> :<tab>]
                            :next :j
                            :open_split [:<c-x>]
                            :open_tab [:<c-t>]
                            :hover :K}
              :padding true
              :mode :workspace_diagnostics
              :height 10
              :auto_preview true
              :auto_close false
              :indent_lines true
              :position :bottom
              :auto_jump {1 :lsp_definitions}
              :fold_closed ""
              :fold_open ""
              :use_diagnostic_signs false
              :auto_open false
              :icons true
              :signs {:information ""
                      :warning ""
                      :hint ""
                      :error ""
                      :other "﫠"}
              :width 50
              :group true
              :auto_fold false}]
     ((. (require :trouble) :setup) opt)
     (local wk (require :which-key))
     (local mappings
            {:t {:name :Toggle
                 :r [(. (require :trouble) :toggle) :Trouble]}})
     (wk.register mappings {:prefix :<leader>})))

{1 :folke/trouble.nvim
 :dependencies [:nvim-tree/nvim-web-devicons]
 :keys [:<leader>tr]
 : config}
