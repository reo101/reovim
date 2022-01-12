(
    (raw_string_literal) @glsl
    (#lua-match? @glsl "^R\"\\([\r\n\t ]*#version %d%d%d")
    (#offset! @glsl 0 3 0 -2)
)
