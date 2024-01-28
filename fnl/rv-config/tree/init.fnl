(fn config []
   (vim.cmd "hi link NeoTreeDirectoryName Directory
             hi link NeoTreeDirectoryIcon NeoTreeDirectoryName")
   (local opt
          {:source_selector
             {:winbar true
              :content_layout :center
              :tabs_layout :equal
              :show_separator_on_edge true
              :sources
                [{:source :filesystem
                  :display_name "󰉓"}
                 {:source :buffers
                  :display_name "󰈙"}
                 {:source :git_status
                  :display_name ""}
                 {:source :diagnostics
                  :display_name "󰒡"}]}
           :view
             {:adaptive_size true}
           :enable_diagnostics true
           :filesystem
             {:filtered_items {:visible false
                               :hide_dotfiles true
                               :hide_gitignored true
                               :hide_by_name []
                               :never_show []}
              :use_libuv_file_watcher true
              :follow_current_file {:enabled true}
              :window {:width 30
                       :mappings {:r "rename"
                                  :c "copy_to_clipboard"
                                  :R "refresh"
                                  :I "toggle_gitignore"
                                  :<C-W> "clear_filter"
                                  :<CR> "open"
                                  :f "filter_on_submit"
                                  :a "add"
                                  :m "move"
                                  :d "delete"
                                  :S "open_split"
                                  :<BS> "navigate_up"
                                  :p "paste_from_clipboard"
                                  :x "cut_to_clipboard"
                                  :<C-X> "clear_filter"
                                  :C "close_node"
                                  :s "open_vsplit"
                                  :. "set_root"
                                  :q "close_window"
                                  :H "toggle_hidden"
                                  :<2-LeftMouse> "open"
                                  :/ "filter_on_submit"}
                       :position :left}
              :group_empty_dirs :true
              :hijack_netrw_behavior :disabled}
           :default_component_configs
             {:name {:use_git_status_colors true
                     :trailing_slash true}
              :indent {:padding 1
                       :indent_size 2
                       :highlight :NeoTreeIndentMarker
                       :last_indent_marker "└"
                       :with_markers true
                       :indent_marker "│"}
              :icon {:folder_open ""
                     :folder_closed ""
                     :folder_empty ""
                     :folder_empty_open ""
                     :default ""}
              :modified {:symbol ""}
              :git_status {:highlight "NeoTreeDimText"}}
           :buffers
             {:show_unloaded true
              :window {:mappings {:r :rename
                                  :d :delete
                                  :c :copy_to_clipboard
                                  :<BS> :navigate_up
                                  :R :refresh
                                  :bd :buffer_delete
                                  :p :paste_from_clipboard
                                  :<2-LeftMouse> :open
                                  :s :open_vsplit
                                  :S :open_split
                                  :x :cut_to_clipboard
                                  :<CR> :open
                                  :a :add
                                  :. :set_root}
                       :position :left}}
           :git_status
             {:window {:mappings {:gg :git_commit_and_push
                                  :r :rename
                                  :c :copy_to_clipboard
                                  :R :refresh
                                  :<2-LeftMouse> :open
                                  :<CR> :open
                                  :S :open_split
                                  :gc :git_commit
                                  :ga :git_add_file
                                  :d :delete
                                  :x :cut_to_clipboard
                                  :gp :git_push
                                  :gr :git_revert_file
                                  :C :close_node
                                  :s :open_vsplit
                                  :p :paste_from_clipboard
                                  :gu :git_unstage_file
                                  :A :git_add_all}
                       :position :float}
              :symbols {;; Change type
                        :added      "" ;; or "✚", but this is redundant info if you use git_status_colors on the name
                        :modified   "" ;; or "", but this is redundant info if you use git_status_colors on the name
                        :deleted    "✖";; this can only be used in the git_status source
                        :renamed    "";; this can only be used in the git_status source
                        ;; Status type
                        :untracked  ""
                        :ignored    ""
                        :unstaged   ""
                        :staged     ""
                        :conflict   ""}}
           :popup_border_style :rounded
           :enable_git_status true
           :close_if_last_window true
           :async_directory_scan :always
           :sort_case_insensitive true})
   ((. (require :neo-tree) :setup) opt)
   (local wk (require :which-key))
   (local mappings
          {:t {:name :Toggle
               :f [(fn []
                    ((. (require :neo-tree)
                        :reveal_current_file)
                     :filesystem
                     true
                     false))
                   :FileTree]}})
   (wk.register mappings {:prefix :<leader>}))

{: config}
