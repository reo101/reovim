; ((shortcut_link) @conceal (#set! conceal "󰄱") (eq? @conceal "[ ]"))
; ((shortcut_link) @conceal (#set! conceal "☒") (eq? @conceal "[x]"))

(atx_heading (inline) @text.title)
(setext_heading (paragraph) @text.title)

[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
  (setext_h1_underline)
  (setext_h2_underline)
] @punctuation.special

[
  (link_title)
  (indented_code_block)
  (fenced_code_block)
] @text.literal

(pipe_table_header (pipe_table_cell) @text.title)

(pipe_table_header "|" @punctuation.special)
(pipe_table_row "|" @punctuation.special)
(pipe_table_delimiter_row "|" @punctuation.special)
(pipe_table_delimiter_cell) @punctuation.special

[
  (fenced_code_block_delimiter)
] @punctuation.delimiter

(code_fence_content) @none

[
  (link_destination)
] @text.uri

[
  (link_label)
] @text.reference

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @punctuation.special


(task_list_marker_unchecked) @text.todo.unchecked
(task_list_marker_checked) @text.todo.checked

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

[
  (backslash_escape)
] @string.escape

([
  ; (info_string)
  (fenced_code_block_delimiter)
 ] @conceal
 (#set! conceal "†"))

([
  (info_string)
 ] @variable)

(inline) @spell
