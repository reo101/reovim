;;; Shared tree-sitter capability checks for runtime consumers.

(fn normal-file-buffer? [bufnr]
  (and bufnr
       (vim.api.nvim_buf_is_valid bufnr)
       (vim.api.nvim_buf_is_loaded bufnr)
       (= (. vim.bo bufnr :buftype) "")
       (not= (vim.api.nvim_buf_get_name bufnr) "")))

(fn buffer-filetype [bufnr ?ft]
  (let [filetype (or ?ft (. vim.bo bufnr :filetype))]
    (if (and filetype (not= filetype ""))
        filetype
        nil)))

(fn filetype-language [filetype]
  (when (and filetype (not= filetype ""))
    (or (vim.treesitter.language.get_lang filetype)
        filetype)))

(fn query-usable? [lang query-name]
  (if (not lang)
      false
      (let [(ok query) (pcall vim.treesitter.query.get lang query-name)
            capture-count (if (and query query.captures)
                            (length query.captures)
                            0)]
        (and ok (> capture-count 0)))))

(fn buffer-state [bufnr ?ft]
  (let [normal? (normal-file-buffer? bufnr)
        filetype (and normal? (buffer-filetype bufnr ?ft))
        lang (filetype-language filetype)
        parser (and lang
                    (let [(ok parser-or-err) (pcall vim.treesitter.get_parser bufnr lang)]
                      (if ok parser-or-err nil)))]
    {:bufnr bufnr
     :filetype filetype
     :highlights? (query-usable? lang :highlights)
     :lang lang
     :normal? normal?
     :parser parser
     :parser? (not (not parser))}))

(fn buffer-has-parser? [bufnr ?ft]
  (. (buffer-state bufnr ?ft) :parser?))

(fn buffer-can-highlight? [bufnr ?ft]
  (let [state (buffer-state bufnr ?ft)]
    (and state.normal? state.parser? state.highlights?)))

(fn buffer-can-fold? [bufnr ?ft]
  (let [state (buffer-state bufnr ?ft)]
    (and state.normal? state.parser?)))

{:buffer-can-fold? buffer-can-fold?
 :buffer-can-highlight? buffer-can-highlight?
 :buffer-filetype buffer-filetype
 :buffer-has-parser? buffer-has-parser?
 :buffer-state buffer-state
 :filetype-language filetype-language
 :normal-file-buffer? normal-file-buffer?
 :query-usable? query-usable?}
