(fn config []
  (set vim.g.parinfer_mode                 :smart)
  (set vim.g.parinfer_enabled              1)
  (set vim.g.parinfer_force_balance        0)
  (set vim.g.parinfer_comment_char         ";")
  (set vim.g.parinfer_string_delimiters    ["\""])
  (set vim.g.parinfer_lisp_vline_symbols   0)
  (set vim.g.parinfer_lisp_block_comments  0)
  (set vim.g.parinfer_guile_block_comments 0)
  (set vim.g.parinfer_scheme_sexp_comments 0)
  (set vim.g.parinfer_janet_long_strings   0))
  ;; (set vim.g.parinfer_logfile              (.. (vim.fn.stdpath :cache) :/parinfer.log)))

{: config}
