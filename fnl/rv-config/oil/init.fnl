(fn after []
  (let [oil (require :oil)
        dk (require :def-keymaps)
        opt {;; Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
             ;; Set to false if you still want to use netrw.
             :default_file_explorer true
             ;; Id is automatically added at the beginning, and name at the end
             ;; See :help oil-columns
             :columns [{:src :permissions
                        :highlight
                          (fn [permission-str]
                            (local permission-hlgroups
                                   {:- :NonText
                                    :r :DiagnosticSignWarn
                                    :w :DiagnosticSignError
                                    :x :DiagnosticSignOk})
                            (-> permission-str
                                (vim.split "")
                                vim.iter
                                (: :enumerate)
                                (: :map #[(. permission-hlgroups $2) (- $1 1) $1])
                                (: :totable)))}
                       :icon]
                       ;; :permissions,
                       ;; :size,
                       ;; :mtime,
             ;; Buffer-local options to use for oil buffers
             :buf_options {:buflisted false
                           :bufhidden "hide"}
             ;; Window-local options to use for oil buffers
             :win_options {:wrap false
                           :signcolumn "no"
                           :cursorcolumn false
                           :foldcolumn "0"
                           :spell false
                           :list false
                           :conceallevel 3
                           :concealcursor "nvi"}
             ;; Restore window options to previous values when leaving an oil buffer
             :restore_win_options true
             ;; Skip the confirmation popup for simple operations
             :skip_confirm_for_simple_edits false
             ;; Deleted files will be removed with the trash_command (below).
             :delete_to_trash false
             ;; Change this to customize the command used when deleting to trash
             :trash_command :trash-put
             ;; Selecting a new/moved/renamed file or directory will prompt you to save changes first
             :prompt_save_on_select_new_entry true
             ;; Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
             ;; options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
             ;; Additionally, if it is a string that matches "actions.<name>",
             ;; it will use the mapping at require("oil.actions").<name>
             ;; Set to `false` to remove a keymap
             ;; See :help oil-actions for a list of all available actions
             ;; TODO: define using `def-keymaps`
             :keymaps {"g?"    :actions.show_help
                       "<CR>"  :actions.select
                       ;; "<C-s>" :actions.select_vsplit
                       ;; "<C-v>" :actions.select_split
                       ;; "<C-t>" :actions.select_tab
                       ;; "<C-p>" :actions.preview
                       "<C-c>" :actions.close
                       "<Esc><Esc>" :actions.close
                       "<C-l>" :actions.refresh
                       "-"     :actions.parent
                       ;; TODO: takovata
                       "<BS>"  :actions.parent
                       "_"     :actions.open_cwd
                       ;; "`"     :actions.cd
                       "~~"    :actions.cd
                       "~t"    :actions.tcd
                       "g."    :actions.toggle_hidden
                       "H"     :actions.toggle_hidden}
             ;; Set to false to disable all of the above keymaps
             :use_default_keymaps true
             :view_options {;; Show files and directories that start with "."
                            :show_hidden false
                            ;; This function defines what is considered a "hidden" file
                            :is_hidden_file (fn [name _bufnr]
                                              (and
                                                ;; TODO: takovata
                                                ;; (not= name "..")
                                                (vim.startswith name ".")))
                            ;; This function defines what will never be shown, even when `show_hidden` is set
                            :is_always_hidden (fn [_name _bufnr]
                                                false)}
             ;; Configuration for the floating window in oil.open_float
             :float {;; Padding around the floating window
                     :padding 2
                     :max_width 0
                     :max_height 0
                     :border "rounded"
                     :win_options {:winblend 10}
                     ;; This is the config that will be passed to nvim_open_win.
                     ;; Change values here to customize the layout
                     :override (fn [conf]
                                 conf)}
             ;; Configuration for the actions floating preview window
             :preview {
                       ;; Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                       ;; min_width and max_width can be a single value or a list of mixed integer/float types.
                       ;; :max_width [100 0.8] means "the lesser of 100 columns or 80% of total"
                       :max_width 0.9
                       ;; :min_width [40 0.4] means "the greater of 40 columns or 40% of total"
                       :min_width [40 0.4]
                       ;; optionally define an integer/float for the exact width of the preview window
                       :width nil
                       ;; Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
                       ;; min_height and max_height can be a single value or a list of mixed integer/float types.
                       ;; :max_height [80 0.9] means "the lesser of 80 columns or 90% of total"
                       :max_height 0.9
                       ;; :min_height [5 0.1] means "the greater of 5 columns or 10% of total"
                       :min_height [5 0.1]
                       ;; optionally define an integer/float for the exact height of the preview window
                       :height nil
                       :border "rounded"
                       :win_options {:winblend 0}}
             ;; Configuration for the floating progress window
             :progress {:max_width 0.9
                        :min_width [40 0.4]
                        :width nil
                        :max_height [10 0.9]
                        :min_height [5 0.1]
                        :height nil
                        :border :rounded
                        :minimized_border :none
                        :win_options {:winblend 0}}}]
    (oil.setup opt)

    (dk :n
        {:t {:group :Toggle
             :o [#(vim.cmd :Oil) :Oil]}}
        {:prefix :<leader>})))

{:src "https://github.com/stevearc/oil.nvim"
 :data {:dependencies [:nvim-tree/nvim-web-devicons]
        ;; :keys [:<leader>to]
        : after}}
