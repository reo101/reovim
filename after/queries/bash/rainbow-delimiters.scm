;; extends

(
  (case_item
    .
    "("? @delimiter
    value: _*
    ")" @delimiter @sentinel) @container
)

(
  (test_command
    .
    "[" @delimiter
    _*
    "]" @delimiter @sentinel
    .) @container
)
