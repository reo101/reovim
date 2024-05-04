(local traversal (require :nvim-paredit.utils.traversal))
(local common    (require :nvim-paredit.utils.common))

(local M {})

;; NOTE: passed
;; (set M.form-types [])
;; (set M.whitespace-chars [])

(fn M.find-next-parent-form [self current-node]
  (if (common.included_in_table self.form-types (current-node:type))
      current-node
      (let [parent (current-node:parent)]
        (if parent
            (self:find-next-parent-form parent)
            current-node))))

(fn M.get-node-root [self node]
  (let [search-point (if (self:node-is-form node)
                         (node:parent)
                         node)
        root (self:find-next-parent-form search-point)]
    (traversal.find_root_element_relative_to root node)))

(fn M.unwrap-form [self node]
  (if (common.included_in_table self self.form-types (node:type))
      node
      (-?> (node:named_child 0)
           (self:unwrap-form))))

(fn M.node-is-form [self node]
  (if (self:unwrap-form node)
      true
      false))

(fn M.node-is-comment [self node]
  (= (node:type) :comment))

(fn M.get-form-edges [self node]
  (fn range-multival-to-table [start-row
                               start-col
                               end-row
                               end-col]
    {: start-row
     : start-col
     : end-row
     : end-col})

  (fn range-table-to-list [{: start-row
                            : start-col
                            : end-row
                            : end-col}]
    [start-row
     start-col
     end-row
     end-col])

  (let [node-range (range-multival-to-table (node:range))
        form (self:unwrap-form node)
        form-range (range-multival-to-table (form:range))
        left-range   {:start-row node-range.start-row
                      :start-col node-range.start-col
                      :end-row   form-range.start-row
                      :end-col   (+ form-range.start-col 1)}
        right-range  {:start-row form-range.end-row
                      :start-col (- form-range.end-col 1)
                      :end-row   form-range.end-row
                      :end-col   form-range.end-col}
        [left-text]  (vim.api.nvim_buf_get_text
                       0
                       left-range.start-row
                       left-range.start-col
                       left-range.end-row
                       left-range.end-col
                       {})
        [right-text] (vim.api.nvim_buf_get_text
                       0
                       right-range.start-row
                       right-range.start-col
                       right-range.end-row
                       right-range.end-col
                       {})]
    (vim.print
      {: left-range
       : left-text
       : right-range
       : right-text})

    {:left  {:text left-text
             :range (range-table-to-list left-range)}
     :right {:text right-text
             :range (range-table-to-list right-range)}}))

(setmetatable
  M
  {:__call
   (fn [self opts]
     (local opts (or opts {}))

     ;;; Validate opts
     (vim.validate
       {:opts
          [opts
           #(and $
                 (= (type $) :table))
           "Invalid `otps` given (has to be a nonempty table of options)"]
        :form-types
          [opts.form-types
           #(and $
                 (= (type $) :table)
                 (vim.isarray $)
                 (not (vim.tbl_isempty $)))
           "Invalid `form-types` given (has to be a nonempty array of treesitter node names)"]
        :whitespace-chars
          [opts.whitespace-chars
           #(and $
                 (not (vim.tbl_isempty $)))
           "Invalid `whitespace-chars` given (has to be a nonempty array of strings"]})

     ;;; Create new table with `opts` set
     (local extension (vim.tbl_extend :force self opts))

     ;;; Convert new table to abide to the `nvim-paredit` extension spec:
     ;;;  - plain functions
     ;;;  - camel_case names
     (collect [name value (pairs extension)]
       (let [camel-name (name:gsub "-" "_")]
         (when (vim.list_contains
                 [:whitespace_chars
                  :get_node_root
                  :unwrap_form
                  :node_is_form
                  :node_is_comment
                  :get_form_edges]
                 camel-name)
           (values camel-name
                   (if (= (type value) :function)
                     ;; method, call on `extension`
                     (fn [...]
                       ;; (vim.print
                       ;;    (string.format
                       ;;      "Called %s with args: %s, on %s"
                       ;;      name
                       ;;      (vim.inspect [...])
                       ;;      (vim.inspect extension))]
                       (value extension ...))
                     ;; else (plain value)
                     value))))))})

M
