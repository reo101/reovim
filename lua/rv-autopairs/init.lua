local M = {}

M.config = function()

    local opt = {
        disable_filetype = { "norg", "TelescopePrompt" },
        ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", ""),
        enable_moveright = true,
        enable_afterquote = true,  -- add bracket pairs after quote
        enable_check_bracket_line = true,  --- check bracket in same line
        check_ts = true,
        ts_config = {
            lua = { "string" }, -- it will not add pair on that treesitter node
            javascript = { "template_string" },
            java = false, -- don't check treesitter on java
        },
    }

    require("nvim-autopairs").setup(opt)

    local optCmp = {
        map_cr = false, --  map <CR> on insert mode
        map_complete = false, -- it will auto insert `(` after select function or method item
        auto_select = false, -- automatically select the first item
    }

    -- require("nvim-autopairs.completion.cmp").setup(optCmp)

    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    require("nvim-treesitter.configs").setup({ autopairs = { enable = true }})

    local ts_conds = require("nvim-autopairs.ts-conds")

    -- press % => %% is only inside comment or string
    autopairs.add_rules({
        Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
        Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    })

end

return M
