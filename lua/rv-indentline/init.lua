local M = {}

M.config = function()

    vim.g.indent_blankline_char = "│"
    vim.g.indent_blankline_use_treesitter = true
    vim.g.indent_blankline_show_current_context = true
    vim.g.indent_blankline_show_trailing_blankline_indent = false
    vim.g.indent_blankline_context_patterns = { "class", "function", "method", "while", "do_statement", "closure", "for" }
    vim.g.indent_blankline_viewport_buffer = 50

    vim.g.indent_blankline_filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
        "startify",
        "packer",
        "neogitstatus",
        "tsplayground",
    }

    vim.g.indent_blankline_buftype_exclude = { "terminal" }

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            i = { function() require("indent_blankline/commands").toggle() end, "IndentLine" },
        },
    }
    
    wk.register(mappings, { prefix = "<leader>" })

end

return M
