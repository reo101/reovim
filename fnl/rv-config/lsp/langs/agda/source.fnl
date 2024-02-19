(local source {})

(local defaults {})

(fn validate-option [params]
  (let [option (vim.tbl_deep_extend :keep params.option defaults)]
    (vim.validate {})
    option))

(fn source.new []
  (let [self (setmetatable {} {:__index source})]
    (tset self :symbols (require :rv-config.lsp.langs.agda.symbols))
    self))

(fn source.get_trigger_characters []
  ["\\"])

(fn source.get_keyword_pattern []
  "\\\\[^[:blank:]]*")

;; FIXME:

(fn source.complete [self request callback]
  (let [_option (validate-option request)]
    (if (not (: (vim.regex (.. (self.get_keyword_pattern) :$))
                :match_str
                request.context.cursor_before_line))
        (callback)
        ;; else
        (callback self.symbols))))

source
