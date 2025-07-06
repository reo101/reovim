; extends

; Code block delimiters - conceal entire ``` lines
((start_delimiter) @conceal
  (#set! conceal ""))

((end_delimiter) @conceal
  (#set! conceal ""))

; Bold **text** - pattern: (start)(content)(end)
((bold) @markup.strong
  (#extmark-gsub! @markup.strong "conceal" "" "^(%*%*)(.-)(%*%*)$"))

; Italic *text*
((italic) @markup.italic
  (#extmark-gsub! @markup.italic "conceal" "" "^(%*)(.-)(%*)$"))

; Code `text`
((code) @markup.raw
  (#extmark-gsub! @markup.raw "conceal" "" "^(`)(.-)(`+)$"))

; Single quote 'text'
((single_quote) @markup.link
  (#extmark-gsub! @markup.link "conceal" "" "^(')(.-)('?)$"))

; Double quote "text"
((double_quote) @markup.quote
  (#extmark-gsub! @markup.quote "conceal" "" "^(\")(.-)(\")$"))

; Autolink <url>
((autolink) @markup.link.url
  (#extmark-gsub! @markup.link.url "conceal" "" "^(<)(.-)(>)$"))
