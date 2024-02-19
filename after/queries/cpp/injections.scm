;; extends

(
  (raw_string_literal
    (raw_string_content) @injection.content)
  (#lua-match? @injection.content "^[%s\n]*#version %d%d%d")
  (#set! injection.language "glsl")
)
