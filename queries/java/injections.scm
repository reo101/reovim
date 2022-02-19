(
  (string_literal) @regex
  (#lua-match? @regex "^\"\^.*\$\"$")
  (#offset! @regex 0 1 0 -1)
)

(
  (method_invocation
    object: (identifier) @_object
    name: (identifier) @_name
    arguments: (argument_list (string_literal) @regex))
  (#any-of? @_object "String" "Pattern")
  (#any-of? @_name "match" "matches" "compile")
  (#offset! @regex 0 1 0 -1)
)
