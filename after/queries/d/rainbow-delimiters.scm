(aggregate_body
  "{" @delimiter
  "}" @delimiter) @container

(aggregate_initializer
  "{" @delimiter
  "}" @delimiter) @container

(block_statement
  "{" @delimiter
  "}" @delimiter) @container

(conditional_declaration
  "{" @delimiter
  "}" @delimiter) @container

(static_foreach_declaration
  "{" @delimiter
  "}" @delimiter) @container

(template_declaration
  "{" @delimiter
  "}" @delimiter) @container

(align_attribute
  "(" @delimiter
  ")" @delimiter) @container

(arguments
  "(" @delimiter
  ")" @delimiter) @container

(assert_expression
  "(" @delimiter
  ")" @delimiter) @container

(at_attribute
  "@" @delimiter
  "(" @delimiter
  ")" @delimiter) @container

(cast_expression
  "(" @delimiter
  ")" @delimiter) @container

(constraint
  "(" @delimiter
  ")" @delimiter) @container

(deprecated_attribute
  "(" @delimiter
  ")" @delimiter) @container

(do_statement
  "(" @delimiter
  ")" @delimiter) @container

(for_statement
  "(" @delimiter
  ")" @delimiter) @container

(foreach_statement
  "(" @delimiter
  ")" @delimiter) @container

(function_literal
  "(" @delimiter
  ")" @delimiter) @container

(if_condition
  "(" @delimiter
  ")" @delimiter) @container

(import_expression
  "(" @delimiter
  ")" @delimiter) @container

(in_contract_expression
  "(" @delimiter
  ")" @delimiter) @container

(is_expression
  "(" @delimiter
  ")" @delimiter) @container

(linkage_attribute
  "(" @delimiter
  ")" @delimiter) @container

(mixin_expression
  "(" @delimiter
  ")" @delimiter) @container

(named_arguments
  "(" @delimiter
  ")" @delimiter) @container

(out_contract_expression
  "(" @delimiter
  ")" @delimiter) @container

(out_statement
  "(" @delimiter
  ")" @delimiter) @container

(parameters
  "(" @delimiter
  ")" @delimiter) @container

(postblit
  "(" @delimiter
  ")" @delimiter) @container

(pragma_expression
  "(" @delimiter
  ")" @delimiter) @container

(primary_expression
  "(" @delimiter
  ")" @delimiter) @container

(static_foreach_declaration
  "(" @delimiter
  ")" @delimiter) @container

(static_if_condition
  "(" @delimiter
  ")" @delimiter) @container

(switch_statement
  "(" @delimiter
  ")" @delimiter) @container

(synchronized_statement
  "(" @delimiter
  ")" @delimiter) @container

(template_parameters
  "(" @delimiter
  ")" @delimiter) @container

(traits_expression
  "(" @delimiter
  ")" @delimiter) @container

(typeid_expression
  "(" @delimiter
  ")" @delimiter) @container

(typeof_expression
  "(" @delimiter
  ")" @delimiter) @container

(with_statement
  "(" @delimiter
  ")" @delimiter) @container

(array_literal
  "[" @delimiter
  "]" @delimiter) @container

(index_expression
  "[" @delimiter
  "]" @delimiter) @container

(type
  "[" @delimiter
  "]" @delimiter) @container

(template_arguments
  "!" @delimiter
  "(" @delimiter
  ")" @delimiter) @container

(template_arguments
  "!" @delimiter
  .
  (_)) @container
