;; extends

;; (
;;     (escape_sequence) @string.escape.nix
;;     (#lua-match? @string.escape.nix "^%'%'%$$")
;;     (#set! conceal "\$")
;; )

(
    (
      (dollar_escape) @_dollar_escape
    ) @string.escape.nix
    (#set! conceal "")
)

(
    (
      (string_fragment) @_dollar
    ) @string.escape.nix
    (#lua-match? @_dollar "^%$$")
)

(
    (escape_sequence) @string.escape.nix
    (#lua-match? @string.escape.nix "^%'%'\\.$")
    (#setgsub! conceal @string.escape.nix "^%'%'\\(.)$" "%1")
)
