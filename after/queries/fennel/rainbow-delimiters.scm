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
