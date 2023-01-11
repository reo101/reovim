local M = {}

M.config = function()

    local opt = {
        ui = {
            bottom = {
                cmdheight = 1,
                laststatus = 0,
                ruler = false,
                showmode = false,
                showcmd = false,
            },
            top = {
                showtabline = 0,
            },
            left = {
                number = false,
                relativenumber = false,
                signcolumn = "no",
            },
        },
        modes = {
            ataraxis = {
                left_padding = 32,
                right_padding = 32,
                top_padding = 1,
                bottom_padding = 1,
                ideal_writing_area_width = { 0 },
                auto_padding = true,
                keep_default_fold_fillchars = true,
                custome_bg = "",
                bg_configuration = true,
                affected_higroups = {
                    NonText = {},
                    FoldColumn = {},
                    ColorColumn = {},
                    VertSplit = {},
                    StatusLine = {},
                    StatusLineNC = {},
                    SignColumn = {},
                },
            },
            focus = {
                margin_of_error = 5,
                focus_method = "experimental",
            },
        },
        integrations = {
            vim_gitgutter = false,
            galaxyline = false,
            tmux = false,
            gitsigns = false,
            nvim_bufferline = false,
            limelight = false,
            vim_airline = false,
            vim_powerline = false,
            vim_signify = false,
            express_line = false,
            lualine = true,
        },
        misc = {
            on_off_commands = false,
            ui_elements_commands = false,
            cursor_by_mode = false,
        },
    }

    require("true-zen").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            z = { function() require("true-zen.main").main(4, "toggle") end, "Zen" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
