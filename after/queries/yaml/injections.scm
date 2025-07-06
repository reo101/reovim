;; extends

(
  (block_scalar
    "|"
    (comment) @injection.language) @injection.content
  (#gsub! @injection.language "#%s+(.*)" "%1")
  (#offset! @injection.content 1 0 0 0)
  (#set! injection.include-children)
)
