;; extends

(
  (command
    name: (command_name) @_name
    argument: (raw_string) @awk
  )
  (#lua-match? @_name "awk")
  (#offset! @awk 0 1 0 -1)
)
