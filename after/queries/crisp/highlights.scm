(comment) @comment

[
  "(" ")"
  "[" "]"
  "{" "}"
  "<" ">"
] @punctuation.bracket

; (boolean) @boolean
; (number) @number

; (string) @string

(symbol) @variable

(sexpr . (symbol) @function)

((symbol) @variable.builtin
 (#match? @variable.builtin "^[$]"))

(binding) @symbol

[
  "fn"
] @keyword.function

(fn [
 (symbol) @function
])


((symbol) @conditional
 (#any-of? @conditional
  "if"))

[
  "let"
] @keyword

((symbol) @keyword
 (#any-of? @keyword
  "comment" "do" "doc" "eval-compiler" "lua" "macros" "quote" "tset" "values"))

((symbol) @function.builtin
 (#any-of? @function.builtin
  "cons" "car" "cdr"))
