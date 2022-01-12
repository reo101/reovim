local M = {}

M.config = function()

    vim.g.parinfer_mode = "smart"
    vim.g.parinfer_enabled = 1
    vim.g.parinfer_force_balance = 0
    vim.g.parinfer_comment_char = ";"
    vim.g.parinfer_string_delimiters = {
        '"',
    }
    vim.g.parinfer_lisp_vline_symbols = 0
    vim.g.parinfer_lisp_block_comments= 0
    vim.g.parinfer_guile_block_comments = 0
    vim.g.parinfer_scheme_sexp_comments = 0
    vim.g.parinfer_janet_long_strings = 0

end

return M
