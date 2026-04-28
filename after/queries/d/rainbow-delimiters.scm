(aggregate_body
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(aggregate_initializer
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(block_statement
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(conditional_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(static_foreach_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(template_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(align_attribute
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(arguments
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(assert_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(at_attribute
  "@" @delimiter
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(cast_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(constraint
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(deprecated_attribute
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(do_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(for_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(foreach_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(function_literal
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(if_condition
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(import_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(in_contract_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(is_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(linkage_attribute
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(mixin_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(named_arguments
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(out_contract_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(out_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(parameters
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(postblit
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(pragma_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(primary_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(static_foreach_declaration
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(static_if_condition
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(switch_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(synchronized_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(template_parameters
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(traits_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(typeid_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(typeof_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(with_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(array_literal
  "[" @delimiter
  "]" @delimiter @sentinel) @container

(index_expression
  "[" @delimiter
  "]" @delimiter @sentinel) @container

(type
  "[" @delimiter
  "]" @delimiter @sentinel) @container

(template_arguments
  "!" @delimiter
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(template_arguments
  "!" @delimiter
  .
  (_) @sentinel) @container
