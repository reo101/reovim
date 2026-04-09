;;; Runtime highlight attach / fallback repair for treesitter consumers.

(fn warn-missing-highlights-query [lang]
  ;; Keep fallback warnings opt-in: some environments intentionally rely on regex syntax.
  (when vim.g.reovim_treesitter_warn_missing_highlights_query
    (vim.notify_once
      (.. "treesitter: no usable highlights query for "
          (tostring lang)
          "; keeping regex syntax highlighting active")
      vim.log.levels.WARN)))

(fn highlights-query-usable? [lang]
  (if (not lang)
      false
      (let [(ok query) (pcall vim.treesitter.query.get lang :highlights)
            capture-count (if (and query query.captures)
                            (length query.captures)
                            0)
            usable? (and ok (> capture-count 0))]
        (when (not usable?)
          (warn-missing-highlights-query lang))
        usable?)))

(fn notify-highlight-short-circuit [lang]
  (vim.notify_once
    (.. "treesitter: short-circuiting highlight attach for "
        (tostring lang)
        " because highlights query is unusable; keeping regex syntax active")
    vim.log.levels.WARN))

(fn stop-buffer-treesitter-highlights [bufnr]
  (let [highlighter (. vim.treesitter.highlighter.active bufnr)]
    (when highlighter
      ;; Stop TS highlights only; keep parser consumers (e.g. rainbow-delimiters) intact.
      (pcall #(highlighter:destroy)))))

(fn normal-file-buffer? [bufnr]
  (and bufnr
       (vim.api.nvim_buf_is_loaded bufnr)
       (= (. vim.bo bufnr :buftype) "")
       (= (vim.fn.buflisted bufnr) 1)
       (not= (vim.api.nvim_buf_get_name bufnr) "")))

(local previous-buffer-syntax {})
(fn set-buffer-regex-syntax [bufnr ft enabled?]
  ;; Disable regex syntax when TS highlights are active to avoid startup flash.
  ;; Re-enable regex syntax only for fallback/no-query buffers.
  (let [bo (. vim.bo bufnr)
        current-syntax (. bo :syntax)
        previous-syntax (. previous-buffer-syntax bufnr)]
    (if enabled?
        (do
          (let [syntax-to-restore (or previous-syntax ft "")]
            (when (and (= current-syntax "")
                       (not= syntax-to-restore ""))
              (tset bo :syntax syntax-to-restore)))
          (tset previous-buffer-syntax bufnr nil))
        (when (not= current-syntax "")
          (tset previous-buffer-syntax bufnr current-syntax)
          (tset bo :syntax "")))))

(local fallback-parser-refresh-tick {})
(fn refresh-buffer-parser-for-fallback [bufnr lang]
  ;; With no highlights query, :edit can clear TS extmarks from parser consumers.
  ;; Re-parse once per changedtick to restore consumers without per-enter churn.
  (let [changedtick (vim.api.nvim_buf_get_changedtick bufnr)
        last-tick (. fallback-parser-refresh-tick bufnr)]
    (when (not= changedtick last-tick)
      (tset fallback-parser-refresh-tick bufnr changedtick)
      (let [(ok parser) (pcall vim.treesitter.get_parser bufnr lang)]
        (when ok
          (pcall #(parser:parse)))))))

(fn ensure-buffer-highlights [bufnr ?ft]
  (when (normal-file-buffer? bufnr)
    (var ft (or ?ft (. vim.bo bufnr :filetype)))
    (when (= ft "")
      (set ft (or (vim.filetype.match {:buf bufnr}) ""))
      (when (not= ft "")
        (tset (. vim.bo bufnr) :filetype ft)))
    (when (not= ft "")
      (let [lang (or (vim.treesitter.language.get_lang ft) ft)]
        (if (highlights-query-usable? lang)
            (do
              (set-buffer-regex-syntax bufnr ft false)
              ;; :edit can detach the TS highlighter for a reused buffer.
              ;; Reattach on demand when we notice it's missing.
              (when (not (. vim.treesitter.highlighter.active bufnr))
                (pcall vim.treesitter.start bufnr lang)))
            ;; Keep regex syntax when no highlights query exists for this language.
            (do
              (notify-highlight-short-circuit lang)
              (set-buffer-regex-syntax bufnr ft true)
              (stop-buffer-treesitter-highlights bufnr)
              (refresh-buffer-parser-for-fallback bufnr lang)))))))

(local pending-highlight-repair {})
(fn queue-buffer-highlights [bufnr ?ft]
  ;; Run repair in the next loop tick to beat post-:edit detach timing.
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

  ;; Disable regex syntax as early as possible for normal file buffers.
  ;; Fallback path will re-enable it for languages without usable TS highlights.
  (vim.api.nvim_create_autocmd [:BufReadPre :BufNewFile]
    {:group repair-group
     :callback
     (fn [ev]
       (when (normal-file-buffer? ev.buf)
         (let [bufname (vim.api.nvim_buf_get_name ev.buf)
               ft (or (. vim.bo ev.buf :filetype)
                      (vim.filetype.match {:filename bufname})
                      (vim.filetype.match {:buf ev.buf})
                      "")]
           (set-buffer-regex-syntax ev.buf ft false))))
     :desc "Disable regex syntax early; fallback reenables when TS highlights are unavailable"})

  ;; Validate highlight attach/fallback state for languages as they appear.
  (vim.api.nvim_create_autocmd :FileType
    {:group repair-group
     :callback
     (fn [ev]
       (queue-buffer-highlights ev.buf ev.match))
     :desc "Repair treesitter highlight state for buffers"})

  ;; :edit and other read paths can drop a previously active TS highlighter.
  ;; Re-check on buffer reads/enters so highlighting persists across reloads.
  (vim.api.nvim_create_autocmd [:BufReadPost :BufWinEnter :BufEnter]
    {:group repair-group
     :callback
     (fn [ev]
       (queue-buffer-highlights ev.buf))
     :desc "Repair treesitter highlight state for buffers"})

  ;; Catch up any buffers that opened before we loaded (for late-loaded plugins)
  (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
    (when (normal-file-buffer? bufnr)
      (queue-buffer-highlights bufnr))))

{:ensure-buffer-highlights ensure-buffer-highlights
 :queue-buffer-highlights queue-buffer-highlights
 :setup setup}
