;; extends

(
  (binding
    attrpath: (attrpath (identifier) @_path)
    expression: [
     (string_expression (string_fragment) @injection.content)
     (indented_string_expression (string_fragment) @injection.content)
    ])
  (#match? @_path "(^\\w+(Phase|Hook)|(pre|post)[A-Z]\\w+|script)$")
  (#set! injection.language "bash")
)

(
  (apply_expression
    function: _ @_function
    argument:
      (attrset_expression
        (binding_set
          binding:
            (binding
              attrpath:
                (attrpath
                  attr:
                    (identifier) @_build)
              expression:
                (indented_string_expression
                   (string_fragment) @injection.content)))))
  (#lua-match? @_function "nuenv.mkDerivation$")
  (#lua-match? @_build "^build$")
  (#set! injection.language "nu")
)
