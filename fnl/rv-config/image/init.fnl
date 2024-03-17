(fn config []
  (let [image (require :image)
        opt {:backend :ueberzug
             :integrations
               {:markdown {:enabled true
                           :clear_in_insert_mode false
                           :download_remote_images true
                           :only_render_image_at_cursor false
                           :filetypes [:markdown
                                       :vimwiki]}
                :neorg {:enabled true
                        :clear_in_insert_mode false
                        :download_remote_images true
                        :only_render_image_at_cursor false
                        :filetypes [:norg]}}
             :max_width nil
             :max_height nil
             :max_width_window_percentage nil
             :max_height_window_percentage 50
             :window_overlap_clear_enabled false
             :window_overlap_clear_ft_ignore [:cmp_menu
                                              :cmp_docs
                                              ""]
             :editor_only_render_when_focused false
             :tmux_show_only_in_active_window false
             :hijack_file_patterns [:*.png
                                    :*.jpg
                                    :*.jpeg
                                    :*.gif
                                    :*.webp]}]
    (each [_ v (ipairs ["/.luarocks/share/lua/5.1/?/init.lua"
                        "/.luarocks/share/lua/5.1/?.lua"])]
      (set package.path
           (.. package.path
               ";"
               ;; "/nix/store/wjddh4i5rjrydq1519ndq3jsml9zxxy0-luajit2.1-magick-1.6.0-1"
               (vim.fn.expand "$HOME")
               v)))
    (image.setup opt)))

{1 :3rd/image.nvim
 :event :VeryLazy
 : config
 :enabled false}
