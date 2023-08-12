;; extends

; TODO: graphviz dot injections

((generic_environment
  (begin
   name: (curly_group_text
           (text) @_env))) @lua
 (#any-of? @_env "luacode"))

((generic_command
  command: (command_name) @_cmd
  arg: (curly_group) @lua)
 (#any-of? @_cmd "\\directlua")
 (#offset! @lua 0 1 0 -1))

; ((generic_environment
;    (begin
;     name: (curly_group_text
;             (text) @_env))
;    (_) @combined @lua
;    (end
;     name: (curly_group_text
;             (text) @_env))
;  )
;  (#any-of? @_env "luacode"))
