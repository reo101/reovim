local M = {}

M.config = function()
    local opt = {
        options = {
            -- Compiled file's destination location
            compile_path = require("nightfox.util").join_paths(vim.fn.stdpath("cache"), "nightfox"),
            compile_file_suffix = "_compiled", -- Compiled file suffix
            transparent = false, -- Disable setting background
            terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*)
            dim_inactive = true, -- Non focused panes set to alternative background
            -- styles = { -- Style to be applied to different syntax groups
            --     comments = "NONE",
            --     functions = "NONE",
            --     keywords = "NONE",
            --     numbers = "NONE",
            --     strings = "NONE",
            --     types = "NONE",
            --     variables = "NONE",
            -- },
            inverse = { -- Inverse highlight for different types
                match_paren = false,
                visual = false,
                search = false,
            },
            modules = { -- List of various plugins and additional options
                -- ...
            },
        },
    }

    require("nightfox").setup(opt)

    vim.cmd("colorscheme nightfox")
end

return M
