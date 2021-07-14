local M = {}

M.config = function()

    -- default, atlantis, andromeda, shusia, maia, espresso
    vim.g.sonokai_style = "maia"

    -- 0, 1
    vim.g.sonokai_disable_italic_comment = 1
    
    -- 1, 0
    vim.g.sonokai_enable_italic = 0

    -- auto, red, orange, yellow, green, blue, purple
    vim.g.sonokai_cursor = "green"

    -- 0, 1
    vim.g.sonokai_transparent_background = 0

    -- blue, green, red
    vim.g.sonokai_menu_selection_background = "green"

    -- 1, 0
    vim.g.sonokai_show_eob = 0

    -- 0, 1
    vim.g.sonokai_diagnostic_text_highlight = 1

    -- no support for nvim-lsp
    vim.g.sonokai_diagnostic_line_highlight = 0

    -- grey, colored
    vim.g.sonokai_diagnostic_virtual_text = "colored"

    -- grey background, bold, underline, italic
    -- Default value: grey background when not in transparent mode, bold when in transparent mode.
    --vim.g.sonokai_current_word

    vim.cmd("colorscheme sonokai")

end

return M
