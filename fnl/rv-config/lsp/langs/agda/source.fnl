(local source {})

(local defaults {})

(fn validate-option [params]
  (let [option (vim.tbl_deep_extend :keep params.option defaults)]
    (vim.validate {})
    option))

(fn source.new []
  (let [self (setmetatable {} {:__index source})]
    (each [k v (pairs (require :rv-config.lsp.langs.agda.symbols))]
      (tset self k v))
    self))

(fn source.get_trigger_characters []
  ["\\"])

(fn source.get_keyword_pattern []
  "\\\\[^[:blank:]]*")

(fn source.complete [self request callback]
  (let [_option (validate-option request)]
    (if (not (: (vim.regex (.. (self.get_keyword_pattern) :$))
                :match_str
                request.context.cursor_before_line))
        (callback)
        ;; else
        (callback self.cmp-symbols))))

source
