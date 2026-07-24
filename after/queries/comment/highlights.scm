((start_delimiter) @conceal
  (#set! conceal ""))

((end_delimiter) @conceal
  (#set! conceal ""))

; Bold **text**
((bold) @markup.strong
  (#extmark-gsub! @markup.strong "conceal" "" "^(%*%*)(.-)(%*%*)$"))

; Italic *text*
((italic) @markup.italic
  (#extmark-gsub! @markup.italic "conceal" "" "^(%*)(.-)(%*)$"))

; Code `text`
((code) @markup.raw.markdown_inline
  (#extmark-gsub! @markup.raw.markdown_inline "conceal" "" "^(`)(.-)(`+)$"))

; Autolink <url>
((autolink) @markup.link.url
  (#extmark-gsub! @markup.link.url "conceal" "" "^(<)(.-)(>)$"))

;;; Base queries

(word) @spell

(mention) @label
(url) @string.special.url
(autolink) @markup.link.url

(taglink) @markup.link

[
  (punctuation)
  (start_delimiter)
  (end_delimiter)
  (injection_delimiter)
] @punctuation.delimiter

type: (_) @type

(task_scope
  (word) @markup.strong)

(breaking) @operator

(_
  type: (word) @comment.note
  (#any-of? @comment.note "PRAISE" "praise" "SUGGESTION" "suggestion" "THOUGHT" "thought" "note" "NOTE" "info" "INFO" "XXX" "BREAKING CHANGE"))

(_
  type: (word) @comment.warning
  (#any-of? @comment.warning "NITPICK" "nitpick" "WARNING" "warning" "FIX" "fix" "HACK" "hack"))

(_
  type: (word) @comment.todo
  (#any-of? @comment.todo "TODO" "todo" "TYPO" "typo" "WIP" "wip"))

(_
  type: (word) @comment.error
  (#any-of? @comment.error "ISSUE" "issue" "ERROR" "error" "FIXME" "fixme" "DEPRECATED" "deprecated"))

(code_block
  language: (string) @label
  content: (code_block_content) @markup.raw)

(comment) @comment

(comment
  property: (string) @label)

(comment
  property: (string) @type
  content: (string) @string)

(comment
  content: (string) @string.special.url
  (#match? @string.special.url "[/\\\\]$"))

(comment
  content: (string) @string.special.url
  (#match? @string.special.url "\\.\\w+$"))

(comment
  property: (string) @constant
  (#any-of? @constant "date" "Date" "Date modified")
  content: (string) @string.special)
