;;; Enable tree-sitter folds only in windows showing supported buffers.

(local capabilities (require :rv-config.treesitter.capabilities))

(fn apply-window-folds [bufnr ?winid]
  (let [winid (or ?winid 0)]
    (vim.api.nvim_win_call winid
      (fn []
        (if (capabilities.buffer-can-fold? bufnr)
            (do
              (tset vim.opt_local :foldmethod :expr)
              (tset vim.opt_local :foldexpr "v:lua.vim.treesitter.foldexpr()"))
            (do
              (tset vim.opt_local :foldmethod :manual)
              (tset vim.opt_local :foldexpr "")))))))

(fn setup []
  (local group
    (vim.api.nvim_create_augroup :ReovimTreesitterFolds {:clear true}))

  (vim.api.nvim_create_autocmd [:FileType :BufWinEnter]
    {:group group
     :callback (fn [ev]
                 (apply-window-folds ev.buf 0))
     :desc "Enable tree-sitter folds only for supported buffers"})

  (each [_ winid (ipairs (vim.api.nvim_list_wins))]
    (apply-window-folds (vim.api.nvim_win_get_buf winid) winid)))

{:apply-window-folds apply-window-folds
 :setup setup}
