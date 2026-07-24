;; extends

(block
  "{" @delimiter
  "}" @delimiter) @container

(struct_or_union_block
  "{" @delimiter
  "}" @delimiter) @container

(enum_declaration
  "{" @delimiter
  "}" @delimiter) @container

(anonymous_enum_type
  "{" @delimiter
  "}" @delimiter) @container

(if_case_statement
  "{" @delimiter
  "}" @delimiter) @container

(parenthesized_expression
  "(" @delimiter
  ")" @delimiter) @container

(insert_parameters
  "(" @delimiter
  ")" @delimiter) @container

(named_parameters
  "(" @delimiter
  ")" @delimiter) @container

(assignment_parameters
  "(" @delimiter
  ")" @delimiter) @container

(procedure_returns
  "(" @delimiter
  ")" @delimiter) @container

(type_of_expression
  "(" @delimiter
  ")" @delimiter) @container

(cast_expression
  "(" @delimiter
  ")" @delimiter) @container

(cast_v2_expression
  "(" @delimiter
  ")" @delimiter) @container

(index_expression
  "[" @delimiter
  "]" @delimiter) @container

(array_type
  "[" @delimiter
  "]" @delimiter) @container

(struct_literal
  "{" @delimiter
  "}" @delimiter) @container

(array_literal
  "[" @delimiter
  "]" @delimiter) @container

(asm_operand
  "[" @delimiter
  "]" @delimiter) @container
