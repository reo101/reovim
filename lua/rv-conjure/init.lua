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
    vim.g["conjure#mapping#def_word"]                  = "jgd"
    vim.g["conjure#mapping#doc_word"]                  = "jK"

    local wk = require("which-key")

    local mappings = {
        j = {
            name = "Conjure",
            l = {
                name = "Log",
                s = { "Split" },
                v = { "VSplit" },
                t = { "Tab" },
                b = { "Buffer" },
                g = { "Toggle" },
                r = { "Reset Soft" },
                R = { "Reset Hard" },
                l = { "Jump To Latest" },
                q = { "Close Visible" },
            },
            e = {
                name = "Eval",
                e = { "Current Form" },
                r = { "Root Form" },
                w = { "Word" },
                c = {
                    name = "Comment",
                    e = { "Current Form" },
                    r = { "Root Form" },
                    w = { "Word" },
                },
                ["!"] = { "Replace Form" },
                m = { "Marked Form" },
                f = { "File" },
                b = { "Buffer" },
            },
            ["gd"] = { "Def Word" },
            ["K"] = { "Doc Word" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local visual_mappings = {
        j = {
            name = "Conjure",
            ["E"] = { "Eval Visual" },
        },
    }

    wk.register(visual_mappings, { mode = "v", prefix = "<leader>" })

    local motion_mappings = {
        j = {
            name = "Conjure",
            ["E"] = { "Eval Motion" },
        },
    }

    wk.register(motion_mappings, { mode = "x", prefix = "<leader>" })
    wk.register(motion_mappings, { mode = "o", prefix = "<leader>" })

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
