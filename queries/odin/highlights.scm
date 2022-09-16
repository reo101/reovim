;; extends

(identifier) @variable

[
  (type_identifier)
] @type

[
  ; "asm"
  "auto_cast"
  ; "bit_set"
  "break"
  "case"
  "cast"
  ; "context"
  "continue"
  "defer"
  "distinct"
  ; "do"
  "dynamic"
  "else"
  "enum"
  "fallthrough"
  "for"
  "foreign"
  "if"
  "import"
  "in"
  "map"
  ; "not_in"
  ; "or_else"
  ; "or_return"
  "package"
  "proc"
  "return"
  "struct"
  "switch"
  "transmute"
  ; "typeid"
  "union"
  "using"
  "when"
  "where"
] @keyword


[
  ";"
  ":"
  ","
] @punctuation.delimiter

[
  "---"
] @punctuation.special

[
  "(" ")"
  "[" "]"
  "{" "}"
] @punctuation.bracket

[
 ;; Multiplicative
 "*"
 "/"
 "%"
 "<<"
 ">>"
 "&"
 "&^"

 ;; Additive
 "+"
 "-"
 "|"
 "^"

 ;; Comparative
 "=="
 "!="
 "<"
 "<="
 ">"
 ">="

 ;; Assignment
 "="
 ":="
 "*="
 "/="
 "%="
 "<<="
 ">>="
 "&="
 "&^="
 "+="
 "-="
 "|="
 "^="
] @operator

[
  (raw_string_literal)
  (interpreted_string_literal)
] @string

[
 (comment)
] @comment


