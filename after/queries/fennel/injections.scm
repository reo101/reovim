;; extends

(
  (binding_pair
    lhs:
      (symbol_binding) @_name
    rhs:
      (string
        content:
          (string_content) @injection.content))
  (#lua-match? @_name "^[^-]*%-query.*$")
  (#set! injection.language "query")
)

(
  (list
    call: (multi_symbol) @_fn
    item: (string content: (string_content) @_lang)
    item: (string content: (string_content) @injection.content))
  (#lua-match? @_fn "^vim.treesitter.query.parse$")
  (#set! injection.language "query")
)

;; (
;;   (binding_pair
;;     lhs:
;;       (symbol_binding) @_name
;;     rhs:
;;       (string
;;         content:
;;           (string_content) @injection.content))
;;   (#lua-match? @_name "^[^-]*%-code.*$")
;;   (#gsub! @_name "(^[^-]*)%-code.*$" "%1")
;;   (#set! injection.language @_name)
;; )
