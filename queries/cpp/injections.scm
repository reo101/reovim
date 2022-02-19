(
  (raw_string_literal) @glsl
  (#lua-match? @glsl "^R\"%(%s*#version %d%d%d")
  (#offset! @glsl 0 3 0 -2)
)
