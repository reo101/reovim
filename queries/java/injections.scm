((string_literal) @regex
  (#lua-match? @regex "^\"\^.*\$\"$")
  (#offset! @regex 0 1 0 -1))

(method_invocation
  object: (identifier) @_object (#any-of? @_object "String" "Pattern")
  name: (identifier) @_name (#any-of? @_name "match" "matches" "compile")
  arguments: (argument_list (string_literal) @regex))
