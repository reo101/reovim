;; extends

(
    (escape_sequence) @string.escape.nix
    (#lua-match? @string.escape.nix "^%'%'%$$")
    (#set! conceal "\$")
)

(
    (escape_sequence) @string.escape.nix
    (#lua-match? @string.escape.nix "^%'%'\\.$")
    (#setgsub! conceal @string.escape.nix "^%'%'\\(.)$" "%1")
)
