(fn after []
  (var saved-terminal nil)
  (let [flatten (require :flatten)
        dk (require :def-keymaps)
        opt {:window
               {:open :alternate}
             :hooks
               {:should_block
                  ;; Note that argv contains all the parts of the CLI command, including
                  ;; Neovim's path, commands, options and files.
                  ;; See: :help v:argv
                  ;;
                  ;; In this case, we would block if we find the `-b` flag
                  ;; This allows you to use `nvim -b file1` instead of
                  ;; `nvim --cmd 'let g:flatten_wait=1' file1`
                  ;;
                  ;; Alternatively, we can block if we find the diff-mode option
                  ;; #(vim.tbl_contains $ :-d)
                  #(vim.tbl_contains $ :-b)
                :pre_open
                  #(let [term (require :toggleterm.terminal)
                         term-id (term.get_focused_id)]
                     (set saved-terminal (term.get term-id)))
                :post_open
                  (fn [{: bufnr : winnr : ft :is_blocking is-blocking}]
                    (vim.print {: is-blocking : saved-terminal})
                    (if (and is-blocking saved-terminal)
                        (saved-terminal:close)
                        (vim.api.nvim_set_current_win winnr))
                    #_
                    (when (->> ft (vim.list_contains
                                    [:gitcommit
                                     :gitrebase]))
                      (vim.api.nvim_create_autocmd
                        :BufWritePost
                        {:buffer bufnr
                         :once true
                         :callback (-> #(vim.api.nvim_buf_delete bufnr {})
                                       vim.schedule_wrap)})))
                :block_end
                  ;; After blocking ends (for a git commit, etc), reopen the terminal
                  #(vim.schedule
                     #(when saved-terminal
                        (if (saved-terminal:is_open)
                            (saved-terminal:focus)
                            (saved-terminal:open))
                        (set saved-terminal nil)))}}]
    (flatten.setup opt)

    (dk :n
        {}
        {:prefix :<leader>})))

{:src "https://github.com/willothy/flatten.nvim"
 :data {;; :version :1.0.0
        :priotity 1001
        : after}}
