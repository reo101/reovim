local M = {}

M.config = function()

    vim.opt.listchars = {
        -- space = "␣",
        nbsp = "␣",
        trail = "",
        -- eol = "↴",
        tab = "  ",
    }
    vim.opt.list = true

    -- vim.cmd [[ highlight ExtraWhitespace ctermbg=red guibg=red ]]
    -- vim.cmd [[ match ExtraWhitespace /\s\+$/ ]]
    -- vim.cmd [[ autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ ]]

    local opt = {
        char = "│",
        space_char_blankline = " ",
        max_indent_increase = 1,
        use_treesitter = true,
        show_end_of_line = false,
        show_current_context = true,
        show_trailing_blankline_indent = false,
        context_patterns = { "class", "function", "method", "while", "do_statement", "closure", "for" },
        viewport_buffer = 50,
        filetype_exclude = {
            "help",
            "terminal",
            "dashboard",
            "startify",
            "packer",
            "neogitstatus",
            "tsplayground",
            "aerial",
        },
        buftype_exclude = { "terminal" },
    }

    require("indent_blankline").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            i = { function()
                require("indent_blankline.commands").toggle()
                vim.cmd [[ set list! ]]
            end, "IndentLine" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
