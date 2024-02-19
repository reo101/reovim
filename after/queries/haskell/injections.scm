;; extends

(
    (comment) @injection.content
    (#lua-match? @injection.content "^-- >>>.")
    (#offset! @injection.content 0 7 0 0)
    (#set! injection.language "haskell")
)
