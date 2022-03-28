local M = {}

M.config = function()

    -- Prefix
    vim.g["conjure#mappings#prefix"]                   = "<leader>j"

    -- Logs
    vim.g["conjure#mapping#log_split"]                 = "jls"
    vim.g["conjure#mapping#log_vsplit"]                = "jlv"
    vim.g["conjure#mapping#log_tab"]                   = "jlt"
    vim.g["conjure#mapping#log_buf"]                   = "jlb"
    vim.g["conjure#mapping#log_toggle"]                = "jlg"
    vim.g["conjure#mapping#log_reset_soft"]            = "jlr"
    vim.g["conjure#mapping#log_reset_hard"]            = "jlR"
    vim.g["conjure#mapping#log_jump_to_latest"]        = "jll"
    vim.g["conjure#mapping#log_close_visible"]         = "jlq"

    -- Evaluation
    vim.g["conjure#mapping#eval_current_form"]         = "jee"
    vim.g["conjure#mapping#eval_comment_current_form"] = "jece"
    vim.g["conjure#mapping#eval_root_form"]            = "jer"
    vim.g["conjure#mapping#eval_comment_root_form"]    = "jecr"
    vim.g["conjure#mapping#eval_word"]                 = "jew"
    vim.g["conjure#mapping#eval_comment_word"]         = "jecw"
    vim.g["conjure#mapping#eval_replace_form"]         = "je!"
    vim.g["conjure#mapping#eval_marked_form"]          = "jem"
    vim.g["conjure#mapping#eval_file"]                 = "jef"
    vim.g["conjure#mapping#eval_buf"]                  = "jeb"
    vim.g["conjure#mapping#eval_visual"]               = "jE"
    vim.g["conjure#mapping#eval_motion"]               = "jE"

    -- Pseudo-LSP
    vim.g["conjure#mapping#def_word"]                  = "gd"
    vim.g["conjure#mapping#doc_word"]                  = "K"

    -- Remove "Sponsored by" message in log
    vim.api.nvim_create_augroup("ConjureRemoveSponsor", {
        clear = true,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "conjure-log-*",
        command = "silent s/; Sponsored by @.*//e",
    })

end

return M
