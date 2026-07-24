;; extends

(
  (string_literal) @injection.content
  (#lua-match? @injection.content "^\"%s*#version %d%d%d")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "glsl")
)

(
  (raw_string_literal) @injection.content
  (#lua-match? @injection.content "^r\"%s*#version %d%d%d")
  (#offset! @injection.content 0 2 0 -2)
  (#set! injection.language "glsl")
)

(
  (raw_string_literal) @injection.content
  (#lua-match? @injection.content "^r#\"%s*#version %d%d%d")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "glsl")
)

(
  (macro_invocation
    macro:
      [
        (scoped_identifier
          name: (_) @_macro_name)
        (identifier) @_macro_name
      ]
    (token_tree) @injection.content)
  (#eq? @_macro_name "sol_interface")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "solidity")
  (#set! injection.include-children)
  (#set! "priority" 128)
)

(
  (
    (block_comment) @injection.language
    .
    (raw_string_literal (string_content) @injection.content)
  )
  (#gsub! @injection.language "/%*%s*([%w%p]+)%s*%*/" "%1")
  (#set! injection.combined)
)

;; (macro_invocation                             ; match a macro invocation
;;   macro: (scoped_identifier                   ; the macro has to be identified with a scoped identifer, of the form module::identifier
;;     path: (identifier) @_macro_path           ; label the macro's module name / path node for later reference
;;     name: (identifier) @_macro_name)          ; label the macro's identifier node for later reference
;;   (token_tree                                 ; the macro should have a token tree argument, because it's a macro
;;     .                                         ; the dot operator anchors to the first sibling, which targets the first macro argument
;;     [                                         ; match a case where the token tree's first child is either a string or a raw string literal
;;     (string_literal
;;       ((string_content) @injection.content))  ; in either case declare the content (the part inside the quotes) is the injection content
;;     (raw_string_literal
;;       ((string_content) @injection.content))
;;     ])
;;   (#eq? @_macro_path "sqlx")                   ; match only if the macro's module name is "sqlx"
;;   (#match? @_macro_name "query(_as|_scalar|)") ; match only if the identifier is one of sqlx's query macro names
;;   (#set! injection.language "sql"))

(
  [
    (macro_invocation
      macro:
        [
          (identifier) @_method
          (scoped_identifier
            name:
              (identifier) @_method)
        ]
      (token_tree
        (_
          (string_content) @injection.content)))
    (call_expression
      function:
        [
          (scoped_identifier
            name: (identifier) @_method)
          (generic_function
            function:
              [
                (field_expression
                  field: (field_identifier) @_method)
                (scoped_identifier
                  name: (identifier) @_method)
              ])
          (field_expression
            field: (field_identifier) @_method)
        ]
      arguments:
        (arguments
          .
          (_
            (string_content) @injection.content)))
  ]
  (#any-of? @_method "execute" "execute_batch" "prepare" "query" "query_row" "query_as")
  (#set! injection.language "sql")
  (#set! "priority" 150)
)
