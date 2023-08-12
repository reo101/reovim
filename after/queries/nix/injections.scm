;; extends

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
               (string_expression (string_fragment) @bash)
               (indented_string_expression (string_fragment) @bash)]
  (#match? @_path "(^\\w+(Phase|Hook)|(pre|post)[A-Z]\\w+|script)$"))
