;; extends

(table_pair
  key:
    (symbol) @_colon @delimiter
  value:
    (symbol) @_value @delimiter
  (#eq? @_colon ":")) @container

(table_pair
  key:
    (string
      content: _ @delimiter)
  value:
    _ @_value) @container

(table_binding_pair
  key:
    (symbol_binding) @_colon @delimiter
  value:
    (symbol_binding) @_value @delimiter
  (#eq? @_colon ":")) @container

(table_binding_pair
  key:
    (string_binding
      content: _ @delimiter)
  value:
    _ @_value) @container
