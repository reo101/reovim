;;; Dynamic Fennel treesitter highlight extension for injected macro/special aliases.

(local fennel-loader (require :fennel-loader))

(local default-capture-by-kind
  {:specials :keyword
   :macros :function.macro})

(fn sorted-copy [xs]
  (let [copy (vim.deepcopy xs)]
    (table.sort copy)
    copy))

(fn current-custom-defs! []
  (fennel-loader.inject-all-global-macros)
  (require :macros.init))

(fn configured-capture [entry]
  (when (= (type entry) :table)
    (let [capture (. entry :capture)]
      (when (= (type capture) :string)
        (capture:gsub "^@" "")))))

(fn alias-highlight-capture [kind entry]
  (or (configured-capture entry)
      (. default-capture-by-kind kind)))

(fn add-highlight! [buckets capture name]
  (when (and capture (= (type name) :string))
    (let [bucket (or (. buckets capture) [])]
      (when (not (vim.tbl_contains bucket name))
        (table.insert bucket name))
      (tset buckets capture bucket))))

(fn collect-highlight-buckets [defs]
  (let [buckets {}]
    (each [name target (pairs (or defs.specials {}))]
      (add-highlight! buckets
                      (alias-highlight-capture :specials target)
                      name))
    (each [name target (pairs (or defs.macros {}))]
      (add-highlight! buckets
                      (alias-highlight-capture :macros target)
                      name))
    buckets))

(fn render-highlight-block [capture names]
  (when (> (length names) 0)
    (let [lines (icollect [_ name (ipairs (sorted-copy names))]
                  (.. "  " (string.format "%q" name)))]
      (.. "((list\n"
          "   call: (symbol) @" capture ")\n"
          " (#any-of? @" capture "\n"
          (table.concat lines "\n")
          "))"))))

(fn dynamic-fennel-highlights-query []
  (let [defs (current-custom-defs!)
        buckets (collect-highlight-buckets defs)
        captures (sorted-copy (vim.tbl_keys buckets))
        blocks (icollect [_ capture (ipairs captures)]
                 (render-highlight-block capture (. buckets capture)))
        non-empty-blocks (icollect [_ block (ipairs blocks)]
                           (when block block))]
    (if (> (length non-empty-blocks) 0)
        (.. ";; extends\n\n"
            ";; Generated from fnl/macros/*\n\n"
            (table.concat non-empty-blocks "\n\n"))
        "")))

(fn apply! []
  (let [dynamic-query (dynamic-fennel-highlights-query)]
    (vim.treesitter.query.set :fennel :highlights
                              (if (= dynamic-query "")
                                  nil
                                  dynamic-query))
    dynamic-query))

(fn fennel-buffer? [bufnr]
  (and (vim.api.nvim_buf_is_loaded bufnr)
       (= (. vim.bo bufnr :filetype) :fennel)))

(fn refresh-open-fennel-buffers! []
  (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
    (when (fennel-buffer? bufnr)
      (pcall #(vim.treesitter.stop bufnr :fennel))
      (pcall #(vim.treesitter.start bufnr :fennel)))))

(fn refresh! []
  (apply!)
  (refresh-open-fennel-buffers!))

(fn setup []
  (apply!)
  (let [group (vim.api.nvim_create_augroup :ReovimFennelTreesitterHighlights
                                           {:clear true})]
    (vim.api.nvim_create_user_command
      :ReovimRefreshFennelHighlights
      #(refresh!)
      {:desc "Regenerate dynamic Fennel treesitter highlight aliases"})
    (vim.api.nvim_create_autocmd
      :BufWritePost
      {:group group
       :pattern ["*/fnl/macros/*.fnl"]
       :callback (fn []
                   (vim.schedule refresh!))
       :desc "Regenerate dynamic Fennel treesitter highlight aliases"})))

{: apply!
 : refresh!
 : setup}
