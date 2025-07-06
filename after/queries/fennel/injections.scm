; Override default comment injection - don't use combined since fennel only has line comments
; The code block syntax (```) won't work across line comments, but other features will
((comment_body) @injection.content
  (#set! injection.language "comment"))
