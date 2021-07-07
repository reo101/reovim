local M = {}

M.config = function()

    local opt = {
        disable_filetype = { "TelescopePrompt" },
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", ""),
        enable_moveright = true,
        enable_afterquote = true,  -- add bracket pairs after quote
        enable_check_bracket_line = true,  --- check bracket in same line
        check_ts = true,

    }

    local optCompe = {
        map_cr = true, --  map <CR> on insert mode
        map_complete = true -- it will auto insert `(` after select function or method item
    }

    require("nvim-autopairs").setup(opt)
    require("nvim-autopairs.completion.compe").setup(optCompe)

end

return M
