; extends

(atom
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(typed_binding
  ["(" "{"] @delimiter
  ":" @delimiter
  [")" "}"] @delimiter @sentinel) @container

(untyped_binding
  ["(" "{"] @delimiter
  ":" @delimiter
  [")" "}"] @delimiter @sentinel) @container
