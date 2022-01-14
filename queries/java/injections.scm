(
    (string_literal) @regex
    (#lua-match? @regex "^\"\^.*\$\"$")
    (#offset! @regex 0 1 0 -1)
)
