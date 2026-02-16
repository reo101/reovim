;;; Dynamic Fennel treesitter highlight extension for injected macro/special aliases.

(local fennel-loader (require :fennel-loader))

(local default-capture-by-kind
  {:specials :keyword
   :macros :function.macro})
(local ignorable-captures
  {:variable true
   :function.call true
   :function.method.call true})
(local capture-cache {})
(local sample-templates
  ["(%s [] 1)"
   "(%s foo [] 1)"
   "(%s true 1)"
   "(%s x 1)"
   "(%s 1)"
   "(%s)"])

(fn sorted-copy [xs]
  (let [copy (vim.deepcopy xs)]
    (table.sort copy)
    copy))

(fn current-custom-defs! []
  (fennel-loader.inject-all-global-macros)
  (require :macros.init))

(fn clone-target [entry]
  (when (and (= (type entry) :table) (not= (. entry :clone) nil))
    (. entry :clone)))

(fn with-fennel-query-buffer [src f]
  (let [bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_lines bufnr 0 -1 false [src])
    (tset (. vim.bo bufnr) :filetype :fennel)
    (let [parser (vim.treesitter.get_parser bufnr :fennel {})
          tree (. (parser:parse) 1)
          root (tree:root)
          query (vim.treesitter.query.get :fennel :highlights)
          result (f bufnr query root)]
      (vim.api.nvim_buf_delete bufnr {:force true})
      result)))

(fn infer-target-capture [target]
  (let [cached (. capture-cache target)]
    (if (not= cached nil)
        cached
        (let [capture
              (accumulate [found nil
                           _ template (ipairs sample-templates)]
                (or found
                    (with-fennel-query-buffer
                      (string.format template target)
                      (fn [bufnr query root]
                        (accumulate [capture nil
                                     id node (query:iter_captures root bufnr 0 -1)]
                          (let [capture-name (. query.captures id)
                                text (vim.treesitter.get_node_text node bufnr)]
                            (if (and (= (node:type) :symbol)
                                     (= text target)
                                     (not (. ignorable-captures capture-name)))
                                capture-name
                                capture)))))))]
          (tset capture-cache target capture)
          capture))))

(fn alias-highlight-capture [kind entry]
  (let [target (or (clone-target entry) entry)]
    (or (and (= (type target) :string)
             (infer-target-capture target))
        (. default-capture-by-kind kind))))

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
