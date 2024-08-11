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
  (#set! include-children)
)
