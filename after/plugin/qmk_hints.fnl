(local treesitter-query-parser (or (?. vim :treesitter :query :parse)
                                   (?. vim :treesitter :parse_query)))

(when (not ((. (require :nvim-treesitter.parsers)
               :has_parser)))
  (lua "return"))

;;; Define query for matching keymap comments
(local keymaps (treesitter-query-parser
                 :c
                 "
;; Keymaps
(
  (declaration
    declarator: (init_declarator
      declarator: (array_declarator
        declarator: (array_declarator
          declarator: (array_declarator
            declarator: (identifier) @_keymaps
          )
        )
      )
      value: (initializer_list
        (comment) @_comment
        (initializer_pair
          designator: (subscript_designator
            (identifier) @_layer
          )
        )
      )
    )
  )
  (#lua-match? @_keymaps \"keymaps\")
  (#set! @_layer \"comment\" @_comment)
)
"))

;;; Define query for matching ledmaps
(local ledmaps (treesitter-query-parser
                   :c
                   "
;; Ledmaps
(
  (declaration
    declarator: (init_declarator
      declarator: (array_declarator
        declarator: (array_declarator
          declarator: (array_declarator
            declarator: (identifier) @_ledmaps
          )
        )
      )
      value: (initializer_list
        (initializer_pair
          designator: (subscript_designator
            (identifier) @_layer
          )
        )
      )
    )
  )
  (#lua-match? @_ledmaps \"ledmaps\")
)
"))

(fn get-root [bufnr]
  (let [parser (vim.treesitter.get_parser bufnr :c {})
        [tree] (parser:parse)]
    (tree:root)))

(fn qmk-helpers [bufnr]
  ;;; Get current buffer
  (local bufnr (or bufnr
                   (vim.api.nvim_get_current_buf)))

  ;;; Early return if not in a C file
  (when (not= (. vim :bo bufnr :filetype)
              :c)
    (vim.notify "This is meant to be used with QMK's keymap.c files")
    (lua "return"))

  ;;; Get the AST root
  (local (ok root) (get-root bufnr))
  (when (not ok)
    (vim.notify 
      (string.format
        "Error: %s"
        root)))

  ;;; Create iterators for both of the TS queries
  (local keymaps_iter_captures (keymaps:iter_captures root bufnr 0 -1))
  (local ledmaps_iter_captures (ledmaps:iter_captures root bufnr 0 -1))

  ;;; Find all keymaps and remember all their comments
  (local keymaps-pairs {})
  (each [pattern matcher metadata (keymaps:iter_matches root bufnr 0 -1)]
    (local pair {})
    (each [id node (pairs matcher)]
      (let [name (. keymaps :captures id)]
        (tset pair name (vim.treesitter.get_node_text node bufnr))))
    (tset keymaps-pairs (. pair :_layer) (. pair :_comment)))

  ;;; Convert raw multi-line string to extmark compatible format
  (fn convert [raw-string start-col]
    (let [virt-lines {}]
      (each [line (: raw-string :gmatch "[^\r\n]+")]
        (let [line (line:match "%*%s.*")]
          (when line
            (table.insert virt-lines [[(..
                                         (string.rep
                                           " "
                                           start-col)
                                         line)
                                       :Comment]]))))
      virt-lines))

  ;;; Create namespace for the extmarks
  (local namespace (vim.api.nvim_create_namespace "QMK"))

  ;;; Clear old extmarks
  (vim.api.nvim_buf_clear_namespace bufnr namespace 0 -1)

  ;;; Find all lightmaps and attach extmarks to them
  (each [pattern matcher metadata (ledmaps:iter_matches root bufnr 0 -1)]
    (each [id node (pairs matcher)]
      (when (= (. ledmaps :captures id)
               :_layer)
        (let [(start-row start-col end-row end-col) (node:range)]
          (vim.api.nvim_buf_set_extmark
            bufnr
            namespace
            start-row
            start-col
            {:virt_lines (convert (. keymaps-pairs
                                     (vim.treesitter.get_node_text
                                       node
                                       bufnr))
                                  start-col)
             :virt_lines_above true}))))))

;;; Define command
(vim.api.nvim_create_user_command "QMK" #(qmk-helpers) {})

;;; Define autocommand
(vim.api.nvim_create_autocmd [:BufEnter :TextChanged :TextChangedI]
                             {:pattern [:keymap.c]
                              :callback #(qmk-helpers)})
