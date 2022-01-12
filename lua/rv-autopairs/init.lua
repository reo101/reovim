local M = {}

M.config = function()

    local opt = {
        disable_filetype = { "norg", "scheme", "TelescopePrompt" },
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
    local cond = require'nvim-autopairs.conds'

    require("nvim-treesitter.configs").setup({ autopairs = { enable = true }})

    local ts_conds = require("nvim-autopairs.ts-conds")

    -- press % => %% is only inside comment or string
    autopairs.add_rules({
        Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
        Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
    })


    autopairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
                local pair = opts.line:sub(opts.col -1, opts.col)
                return vim.tbl_contains({ '()', '{}', '[]' }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local context = opts.line:sub(col - 1, col + 2)
                return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
            end),
        Rule('', ' )')
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == ')' end)
            :with_cr(cond.none())
            :with_del(cond.none())
            :use_key(')'),
        Rule('', ' }')
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == '}' end)
            :with_cr(cond.none())
            :with_del(cond.none())
            :use_key('}'),
        Rule('', ' ]')
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == ']' end)
            :with_cr(cond.none())
            :with_del(cond.none())
            :use_key(']'),
    }

end

return M
