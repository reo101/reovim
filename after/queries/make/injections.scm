;; extends

(
  (define_directive
    name: _
    value: (raw_text) @injection.content)
  (#set! injection.language "make")
  (#set! injection.combined)
)

(
  (function_call
    "$"
    "("
    "eval"
    (arguments) @injection.content
    ")")
  (#set! injection.language "make")
  (#set! injection.include-children)
)

(
  (define_directive
    name: (word) @_GUILE
    value: (raw_text) @injection.content)
  (#lua-match? @_GUILE "^GUILE")
  (#set! injection.language "scheme")
  (#set! injection.include-children)
)
