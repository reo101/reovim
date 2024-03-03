;; extends

(
  (list
    call:
      (symbol) @_local
    item:
      (symbol) @_name
    item:
      (string
        content:
          (string_content) @injection.content))
  (#eq? @_local "local")
  (#lua-match? @_name "^[^-]*%-query%-string.*$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "query")
)
