;;; Custom treesitter directives and predicates used by local queries.

(fn setup []
  ;; setgsub! - gsub on captured node text, store in metadata
  ;; (#setgsub! metadata_key capture_idx pattern replacement)
  (vim.treesitter.query.add_directive
    :setgsub!
    (fn [matches _ts-pattern bufnr list metadata]
      (let [[_directive key capture_id pattern replacement] list]
        (tset metadata key
              (string.gsub
                (vim.treesitter.get_node_text (. matches capture_id) bufnr
                  {:metadata (. metadata capture_id)})
                pattern
                replacement))))
    true)

  ;; extmark-gsub! - mark delimiter positions with extmarks
  ;; Pattern must capture (start_delim)(content)(end_delim)
  ;; Example: (#extmark-gsub! @bold "conceal" "" "^(%*%*)(.-)(%*%*)$")
  (local extmark-ns (vim.api.nvim_create_namespace :extmark-delims))
  (vim.treesitter.query.add_directive
    :extmark-gsub!
    (fn [matches _ts-pattern bufnr list _metadata]
      (let [[_directive capture_id prop value pattern] list
            match-data (. matches capture_id)
            node (if (vim.islist match-data) (. match-data 1) match-data)]
        (when node
          (let [text (vim.treesitter.get_node_text node bufnr)
                (start_delim _content end_delim) (string.match text pattern)]
            (when (and start_delim end_delim)
              (let [(sr sc er ec) (node:range)
                    start_len (length start_delim)
                    end_len (length end_delim)]
                (when (> start_len 0)
                  (vim.api.nvim_buf_set_extmark bufnr extmark-ns sr sc
                    {:end_row sr :end_col (+ sc start_len) prop value}))
                (when (> end_len 0)
                  (vim.api.nvim_buf_set_extmark bufnr extmark-ns er (- ec end_len)
                    {:end_row er :end_col ec prop value}))))))))
    true)

  ;; Skip if any child contains one of these text values
  (vim.treesitter.query.add_predicate
    :has-no-child?
    (fn [matches _ts-pattern bufnr pred]
      (let [[_directive capture_id & not-wanted] pred
            [node] (. matches capture_id)]
        (not
          (faccumulate [any false i 0 (- (node:child_count) 1)]
            (let [child (node:child i)
                  child-text (vim.treesitter.get_node_text child bufnr)]
              (or any (vim.tbl_contains not-wanted child-text)))))))
    {:all true}))

{:setup setup}
