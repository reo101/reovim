local M = {}

M.config = function()

    local autopairs = require("nvim-autopairs")

    local opt = {
        disable_filetype = { "norg", "scheme", "TelescopePrompt" },
        disable_in_macro = false,         -- disable when recording or executing a macro
        disable_in_visualblock = false,   -- disable when insert after visual block mode
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,         -- add bracket pairs after quote
        enable_check_bracket_line = true, -- check bracket in same line
        enable_bracket_in_quote = true,   --
        enable_abbr = false,              -- trigger abbreviation
        break_undo = true,                -- switch for basic rule break undo sequence
        check_ts = true,
        ts_config = {
            lua = { "string" }, -- it will not add pair on that treesitter node
            javascript = { "template_string" },
            java = false,       -- don't check treesitter on java
        },
        map_cr = true,
        map_bs = true,   -- map the <BS> key
        map_c_h = false, -- Map the <C-h> key to delete a pair
        map_c_w = false, -- map <c-w> to delete a pair if possible
    }

    autopairs.setup(opt)

    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

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
