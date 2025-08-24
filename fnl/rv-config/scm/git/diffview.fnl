(fn after []
  (let [da (require :diffview.actions)
        opt {:diff_binaries false
             :enhanced_diff_hl false
             :file_history_panel {:log_options {:git {:all false
                                                      :merges false
                                                      :multi_file {:max_count 128}
                                                      :no_merges false
                                                      :reverse false
                                                      :single_file {:follow false
                                                                    :max_count 512}}}
                                  :win_config {:height 16
                                               :position :bottom
                                               :width 35}}
             :file_panel {:listing_style :tree
                          :tree_options {:flatten_dirs true
                                         :folder_statuses :always}
                          :win_config {:height 10
                                       :position :left
                                       :width 35}}
             :icons {:folder_closed "" :folder_open ""}
             :key_bindings {:disable_defaults false
                            :file_history_panel {:<2-LeftMouse> da.select_entry
                                                 :<C-d> da.open_in_diffview
                                                 :<C-w><C-f> da.goto_file_split
                                                 :<C-w>gf da.goto_file_tab
                                                 :<c-b> (da.scroll_view (- 0.25))
                                                 :<c-f> (da.scroll_view 0.25)
                                                 :<cr> da.select_entry
                                                 :<down> da.next_entry
                                                 :<leader>b da.toggle_files
                                                 :<leader>e da.focus_files
                                                 :<s-tab> da.select_prev_entry
                                                 :<tab> da.select_next_entry
                                                 :<up> da.prev_entry
                                                 :L da.open_commit_log
                                                 :g! da.options
                                                 :g<C-x> da.cycle_layout
                                                 :gf da.goto_file
                                                 :j da.next_entry
                                                 :k da.prev_entry
                                                 :o da.select_entry
                                                 :y da.copy_hash
                                                 :zM da.close_all_folds
                                                 :zR da.open_all_folds}
                            :file_panel {:- da.toggle_stage_entry
                                         :<2-LeftMouse> da.select_entry
                                         :<C-w><C-f> da.goto_file_split
                                         :<C-w>gf da.goto_file_tab
                                         :<c-b> (da.scroll_view (- 0.25))
                                         :<c-f> (da.scroll_view 0.25)
                                         :<cr> da.select_entry
                                         :<down> da.next_entry
                                         :<leader>b da.toggle_files
                                         :<leader>e da.focus_files
                                         :<s-tab> da.select_prev_entry
                                         :<tab> da.select_next_entry
                                         :<up> da.prev_entry
                                         :L da.open_commit_log
                                         :R da.refresh_files
                                         :S da.stage_all
                                         :U da.unstage_all
                                         :X da.restore_entry
                                         "[x" da.prev_conflict
                                         "]x" da.next_conflict
                                         :f da.toggle_flatten_dirs
                                         :g<C-x> da.cycle_layout
                                         :gf da.goto_file
                                         :i da.listing_style
                                         :j da.next_entry
                                         :k da.prev_entry
                                         :o da.select_entry}
                            :option_panel {:<tab> da.select_entry
                                           :q da.close}
                            :view {:<C-w><C-f> da.goto_file_split
                                   :<C-w>gf da.goto_file_tab
                                   :<leader>b da.toggle_files
                                   :<leader>e da.focus_files
                                   :<s-tab> da.select_prev_entry
                                   :<tab> da.select_next_entry
                                   :gf da.goto_file}}
             :signs {:fold_closed "" :fold_open ""}
             :use_icons true}]
    ((. (require :diffview) :setup) opt)))

{:src "https://github.com/sindrets/diffview.nvim"
 :data {:lazy true
        : after}}
