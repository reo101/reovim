; TODO: Individual line offset
(
  (LINESTRING) @glsl
  (#lua-match? @glsl "^\\\\%s*#version %d%d%d")
  (#offset! @glsl 0 2 0 0)
)
