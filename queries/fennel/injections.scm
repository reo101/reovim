;; extends

(
  (local
    (binding
      (symbol) @_name)
    (string) @query)
  (#lua-match? @_name "^[^-]*%-query%-string.*$")
  (#offset! @query 0 1 0 -1)
)
