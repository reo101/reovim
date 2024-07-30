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

(
  (call_expression
    function:
      [
        (generic_function
          function:
            (field_expression
              field: (field_identifier) @_method))
        (field_expression
          field: (field_identifier) @_method)
      ]
    arguments: (arguments
      .
      (_
        (string_content) @injection.content)))
    (#any-of? @_method "execute" "execute_batch" "prepare" "query" "query_row")
    (#set! injection.language "sql")
    (#set! "priority" 128)
)
