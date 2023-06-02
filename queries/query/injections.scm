;; extends

(
  (predicate
    name:
      (identifier) @_name
    parameters:
      (parameters (string) @luap))
  (#match? @_name "^#?setgsub$")
  (#offset! @luap 0 1 0 -1)
)
