local M = {}

M.config = function()

    local opt = {
        fox = "nightfox", -- change the colorscheme to use nordfox
        styles = {
            comments = "italic", -- change style of comments to be italic
            keywords = "bold", -- change style of keywords to be bold
            functions = "italic,bold" -- styles can be a comma separated list
        },
        colors = {
            red = "#FF000", -- Override the red color for MAX POWER
            bg_alt = "#000000",
        },
        hlgroups = {
            TSPunctDelimiter = { fg = "${red}" }, -- Override a highlight group with the color red
            LspCodeLens = { bg = "#000000", style = "italic" },
        }
    }

    require("nightfox").setup(opt)
    require("nightfox").load()

end

return M
