local M = {}

M.config = function()
    local opt = {
        keep_indentation = false,
        fill_char = "━",
        sections = {
            left = {
                "━━",
                function()
                    return string.rep(">", vim.v.foldlevel)
                end,
                "━━┫",
                "content",
                "┣",
            },
            right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
            },
        },
    }

    require("pretty-fold").setup(opt)
    require("pretty-fold.preview").setup({ key = "l" })
end

return M
