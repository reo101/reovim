local M = {}

M.config = function()

    local opt = {
        variant = "midnight",
        disable = {
            background = true,
            endOfBuffer = true,
        },
        italic = {
            comments   = false,
            keywords   = true,
            functions  = false,
            variables  = true,
        },
        custom_colors = { -- this table can hold any group of colors with their respective values
            LineNr = { fg = "#5BBBDA", bg = "NONE", style = "NONE" },
            CursorLineNr = { fg = "#E1CD6C", bg = "NONE", style = "NONE" },

            -- it is possible to specify only the element to be changed
            TelescopePreviewBorder = { fg = "#A13413" },
            LspDiagnosticsDefaultError = { bg = "#E11313" },
            TSTagDelimiter = { style = "bold,italic" },
        }
    }

    require("nebulous").setup(opt)

    vim.cmd("colorscheme nebulous")

end

return M
