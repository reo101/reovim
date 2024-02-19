;; extends

(
  (command
    name: (command_name) @_cmd
    argument: (raw_string) @injection.content
  )
  (#offset! @injection.content 0 1 0 -1)
  (#lua-match? @_cmd "awk")
  (#set! injection.language "awk")
)
