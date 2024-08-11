;; extends

(left_section
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(right_section
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(arithmetic_sequence
  "[" @delimiter
  "]" @delimiter @sentinel) @container
