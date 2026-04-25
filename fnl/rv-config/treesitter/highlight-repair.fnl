;;; Explicit tree-sitter highlight attach for buffers that actually support it.

(local capabilities (require :rv-config.treesitter.capabilities))

(local attached-language {})

(fn ensure-buffer-highlights [bufnr ?ft]
  (let [state (capabilities.buffer-state bufnr ?ft)]
    (if (and state.normal? state.parser? state.highlights?)
        (when (or (not (. vim.treesitter.highlighter.active bufnr))
                  (not= (. attached-language bufnr) state.lang))
          (pcall vim.treesitter.start bufnr state.lang)
          (tset attached-language bufnr state.lang))
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

  ;; Catch up any buffers that opened before we loaded (for late-loaded plugins)
  (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
    (when (capabilities.normal-file-buffer? bufnr)
      (queue-buffer-highlights bufnr))))

{:ensure-buffer-highlights ensure-buffer-highlights
 :queue-buffer-highlights queue-buffer-highlights
 :setup setup}
