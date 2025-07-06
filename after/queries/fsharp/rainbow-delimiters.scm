;; Patterns with parentheses
(argument_patterns
  ("(" @delimiter ")" @delimiter)*) @container

(paren_pattern
  "(" @delimiter
  ")" @delimiter) @container

(paren_type
  "(" @delimiter
  ")" @delimiter) @container

(paren_expression
  "(" @delimiter
  ")" @delimiter) @container

(primary_constr_args
  "(" @delimiter
  ")" @delimiter) @container

(active_pattern
  "(|" @delimiter
  "|"* @delimiter
  "|)" @delimiter) @container

;; Expressions with parentheses
(begin_end_expression
  "begin" @delimiter
  "end" @delimiter) @container

;; Lists with square brackets
(list_expression
  "[" @delimiter
  "]" @delimiter) @container

(list_pattern
  "[" @delimiter
  "]" @delimiter) @container

;; Arrays with [| |]
(array_expression
  "[|" @delimiter
  "|]" @delimiter) @container

(array_pattern
  "[|" @delimiter
  "|]" @delimiter) @container

;; Index expressions with brackets
(index_expression
  ".[" @delimiter
  "]" @delimiter) @container

;; Records and anonymous records with curly braces
(record_type_defn
  "{" @delimiter
  "}" @delimiter) @container

(anon_record_expression
  "{|" @delimiter
  "|}" @delimiter) @container

(brace_expression
  "{" @delimiter
  "}" @delimiter) @container

;; Computation expressions
(ce_expression
  "{" @delimiter
  "}" @delimiter) @container

;; Function application with parentheses
(application_expression
  "(" @delimiter
  ")" @delimiter) @container

;; Generic/Type arguments with angle brackets
(generic_type
  "<" @delimiter
  ">" @delimiter) @container

(type_arguments
  "<" @delimiter
  ">" @delimiter) @container

;; Control flow expressions
(if_expression
  "if" @delimiter
  "then" @delimiter
  ("else" @delimiter)?) @container

(elif_expression
  "elif" @delimiter
  "then" @delimiter) @container

(match_expression
  "match" @delimiter
  "with" @delimiter
  (rules
    [
      ("|" @delimiter)
      (rule
        "->" @delimiter)
    ]*)) @container

(for_expression
  "for" @delimiter
  ("do" @delimiter)?) @container

(while_expression
  "while" @delimiter
  "do" @delimiter) @container

;; Special: unit is both a container and a delimiter
(unit) @delimiter @container
