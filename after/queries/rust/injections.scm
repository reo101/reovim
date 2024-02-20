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
