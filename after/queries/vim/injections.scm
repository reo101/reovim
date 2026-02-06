;; extends

(
  (user_command
    (command_name) @_cmd
    (arguments) @injection.content)
  (#eq? @_cmd "Fnl")
  (#set! injection.language "fennel")
  (#set! injection.include-children)
)
