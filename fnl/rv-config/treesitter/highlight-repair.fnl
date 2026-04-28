;;; Explicit tree-sitter highlight attach for buffers that actually support it.

(local capabilities (require :rv-config.treesitter.capabilities))

(local attached-language {})

(fn maybe-redraw-current-buffer [bufnr]
  ;; When the initial buffer gets its highlighter on a deferred tick, the first
  ;; screen paint may already have happened. Redraw so the user sees highlights
  ;; immediately instead of waiting for the next manual interaction.
  (when bufnr
    (vim.schedule
      (fn []
        (when (and (= bufnr (vim.api.nvim_get_current_buf))
                   (. vim.treesitter.highlighter.active bufnr))
          (vim.cmd "redraw!"))))))

(fn ensure-buffer-highlights [bufnr ?ft]
  (let [state (capabilities.buffer-state bufnr ?ft)]
    (if (and state.normal? state.parser? state.highlights?)
        (when (or (not (. vim.treesitter.highlighter.active bufnr))
                  (not= (. attached-language bufnr) state.lang))
          (pcall vim.treesitter.start bufnr state.lang)
          (tset attached-language bufnr state.lang)
          (maybe-redraw-current-buffer bufnr))
        (tset attached-language bufnr nil))))

(local pending-highlight-repair {})
(fn queue-buffer-highlights [bufnr ?ft]
  ;; Run on the next loop tick so post-:edit detaches settle before we re-attach.
  (when bufnr
    (tset pending-highlight-repair bufnr true)
    (vim.schedule
      (fn []
        (when (. pending-highlight-repair bufnr)
          (tset pending-highlight-repair bufnr nil)
          (ensure-buffer-highlights bufnr ?ft))))))

(fn setup []
  (local repair-group
    (vim.api.nvim_create_augroup :ReovimTreesitterRepair {:clear true}))

  (vim.api.nvim_create_autocmd :FileType
    {:group repair-group
     :callback
     (fn [ev]
       (queue-buffer-highlights ev.buf ev.match))
     :desc "Attach tree-sitter highlights for supported buffers"})

  (vim.api.nvim_create_autocmd [:BufReadPost :BufWinEnter :BufEnter]
    {:group repair-group
     :callback
     (fn [ev]
       (queue-buffer-highlights ev.buf))
     :desc "Re-attach tree-sitter highlights when supported buffers are reloaded"})

  (vim.api.nvim_create_autocmd :VimEnter
    {:group repair-group
     :once true
     :callback
     (fn []
       (ensure-buffer-highlights (vim.api.nvim_get_current_buf)))
     :desc "Attach tree-sitter highlights for the initial startup buffer"})

  ;; Catch up any buffers that opened before we loaded (for late-loaded plugins)
  (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
    (when (capabilities.normal-file-buffer? bufnr)
      (ensure-buffer-highlights bufnr))))

{:ensure-buffer-highlights ensure-buffer-highlights
 :queue-buffer-highlights queue-buffer-highlights
 :setup setup}
