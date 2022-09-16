;; extends

; TODO: graphviz dot injections

((generic_environment
  (begin
   name: (curly_group_text
           (text) @_env))) @lua
 (#any-of? @_env "luacode"))

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
