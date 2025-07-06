;; extends

;; TODO: why no effect?
(fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content) @injection.content
  (#eq? @_lang "typc")
  (#set! injection.language "typst"))
