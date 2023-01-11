(fn config []
  (let [opt {:extensions {:file_browser {:theme :ivy
                                         :mappings {:n {} :i {}}}
                          :ui-select {1 ((. (require :telescope.themes)
                                            :get_cursor) {:winblend 10
                                                          :previewer false
                                                          :shorten_path false
                                                          :border true})}
                          :fzf {:case_mode :smart_case
                                :override_generic_sorter false
                                :override_file_sorter true
                                :fuzzy true}
                          :media_files {:filetypes {}}}
             :defaults {:borderchars {1 "─"
                                      2 "│"
                                      3 "─"
                                      4 "│"
                                      5 "╭"
                                      6 "╮"
                                      7 "╯"
                                      8 "╰"}
                        :path_display {}
                        :color_devicons true
                        :wrap_results true
                        :winblend 20
                        :mappings {:i {:<C-s> (. (require :trouble.providers.telescope)
                                                 :open_with_trouble)}}}}]
    ((. (require :telescope) :setup) opt)
    ;; (when (= (vim.fn.executable :fzf) 1)
    ;;   ((. (require :telescope) :load_extension) :fzf))
    (when (= (vim.fn.executable :gh) 1)
      ((. (require :telescope) :load_extension) :gh))
    (when (= (vim.fn.executable :ueberzug) 1)
      ((. (require :telescope) :load_extension) :media_files))
    ;; ((. (require :telescope) :load_extension) :notify)
    ;; ((. (require :telescope) :load_extension) :aerial)
    ((. (require :telescope) :load_extension) :file_browser)
    (local actions (require :telescope.actions))
    (local action-state (require :telescope.actions.state))
    (local themes (require :telescope.themes))
    (local functions {})

    (fn functions.find_files []
      (if (< vim.o.columns 128)
        ((. (require :telescope.builtin) :find_files) ((. (require :telescope.themes)
                                                          :get_dropdown)))
        ((. (require :telescope.builtin) :find_files))))

    (fn functions.buffer_git_files []
      ((. (require :telescope.builtin) :git_files) 
       (themes.get_dropdown {:border true
                             :winblend 10
                             :cwd (vim.fn.expand "%:p:h")
                             :shorten_path false
                             :previewer false})))

    (fn functions.live_grep []
      ((. (require :telescope.builtin) :live_grep) {:previewer false
                                                    :fzf_separator "|>"}))

    (fn functions.grep_prompt []
      ((. (require :telescope.builtin) :grep_string) {:search (vim.fn.input "Grep String > ")
                                                      :path_display {1 :shorten}}))

    (fn functions.grep_last_search [opts]
      (set-forcibly! opts (or opts {}))
      (local register
        (: (: (: (vim.fn.getreg "/") :gsub "\\<" "") :gsub
              "\\>" "") :gsub
           "\\C" ""))
      (set opts.path_display {1 :shorten})
      (set opts.word_match :-w)
      (set opts.search register)
      ((. (require :telescope.builtin) :grep_string) opts))

    (fn functions.oldfiles []
      ((. (require :telescope.builtin) :oldfiles)))

    (fn functions.installed_plugins []
      ((. (require :telescope.builtin) :find_files) {:cwd (.. (vim.fn.stdpath :data)
                                                              :/site/pack/packer/start/)}))

    (fn functions.buffers []
      ((. (require :telescope.builtin) :buffers) {:shorten_path false}))

    (fn functions.curbuf []
      (let [opts (themes.get_dropdown {:winblend 10
                                       :previewer false
                                       :shorten_path false
                                       :border true})]
        ((. (require :telescope.builtin)
            :current_buffer_fuzzy_find) opts)))

    (fn functions.search_all_files []
      ((. (require :telescope.builtin) :find_files) {:find_command {1 :rg
                                                                    2 :--no-ignore
                                                                    3 :--files}}))

    (local wk (require :which-key))
    (local mappings
      {:f {:f {1 functions.find_files 2 "Find File"}
           :c {1 functions.curbuf 2 "Current Buffer"}
           :s {1 functions.grep_promp 2 "Static grep"}
           :F {1 functions.search_all_files 2 "All Files"}
           :b {1 functions.buffers 2 :Buffers}
           :p {1 functions.installed_plugins 2 :Plugins}
           :g {1 functions.live_grep 2 "Live Grep"}
           :G {1 functions.grep_last_search 2 "Last Grep"}
           :name :Find
           :r {1 functions.oldfiles 2 "Recent Files"}}})
    (wk.register mappings {:prefix :<leader>})))

{: config}
