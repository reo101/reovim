;; extends

(
  (
    (comment) @_prompt @injection.content
  )

  (#lua-match? @_prompt "^\-\- >>> [^%s]")
  ;; NOTE: match prompt line (after `-- >>>`)
  (#offset! @injection.content 0 7 0 0)
  (#set! injection.language "haskell")
)

(
  (
    (comment) @_prompt @injection.content
  )

  (#lua-match? @_prompt "^\-\- >>> [^%s]")
  (#lua-match? @_prompt "^[^%n]*\n%-%- [^%s]")
  ;; NOTE: match result line (after `-- `)
  (#offset! @injection.content 1 3 0 0)
  (#set! injection.language "haskell")
)
