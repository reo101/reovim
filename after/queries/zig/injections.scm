;; extends

;; TODO: Individual line offset
(
  (multiline_string) @injection.content
  (#lua-match? @injection.content "^\\\\%s*#version %d%d%d")
  (#offset! @injection.content 0 2 0 0)
  (#set! injection.language "glsl")
  (#set! injection.combined)
)
