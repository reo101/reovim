local M = {}

M.config = function()

    -- number#decimal                   decimal natural number                              0, 1, ..., 9, 10, 11, ...
    -- number#decimal#int               decimal integer (including negative number)         0, 314, -1592, ...
    -- number#decimal#fixed#zero        fixed-digit decimal number (0 padding)              00, 01, ..., 11, ..., 99
    -- number#decimal#fixed#space       fixed-digit decimal number (half space padding)     ␣0, ␣1, ..., 11, ..., 99
    -- number#hex                       hex natural number                                  0x00, 0x3f3f, ...
    -- number#octal                     octal natural number                                000, 011, 024, ...
    -- number#binary                    binary natural number                               0b0101, 0b11001111, ...
    -- date#[%Y/%m/%d]                  Date in the format %Y/%m/%d (0 padding)             2021/01/04, ...
    -- date#[%m/%d]                     Date in the format %m/%d (0 padding)                01/04, 02/28, 12/25, ...
    -- date#[%-m/%-d]                   Date in the format %-m/%-d (no paddings)            1/4, 2/28, 12/25, ...
    -- date#[%Y-%m-%d]                  Date in the format %Y-%m-%d (0 padding)             2021-01-04, ...
    -- date#[%Y年%-m月%-d日]            Date in the format %Y年%-m月%-d日 (no paddings)     2021年1月4日, ...
    -- date#[%Y年%-m月%-d日(%ja)]       Date in the format %Y年%-m月%-d日(%ja)              2021年1月4日(月), ...
    -- date#[%H:%M:%S]                  Time in the format %H:%M:%S                         14:30:00, ...
    -- date#[%H:%M]                     Time in the format %H:%M                            14:30, ...
    -- date#[%ja]                       Japanese weekday                                    月, 火, ..., 土, 日
    -- date#[%jA]                       Japanese full weekday                               月曜日, 火曜日, ..., 日曜日
    -- char#alph#small#word             Lowercase alphabet letter (word)                    a, b, c, ..., z
    -- char#alph#capital#word           Uppercase alphabet letter (word)                    A, B, C, ..., Z
    -- char#alph#small#str              Lowercase alphabet letter (string)                  a, b, c, ..., z
    -- char#alph#capital#str            Uppercase alphabet letter (string)                  A, B, C, ..., Z
    -- color#hex                        hex triplet                                         #00ff00, #ababab, ...
    -- markup#markdown#header           Markdown Header                                     #, ##, ..., ######

    local dial = require("dial")

    ----------------------------------------
    --              DEFAULTS              --
    ----------------------------------------
    -- Augend Name 	                N   V --
    -- number#decimal 	            ✓ 	✓ --
    -- number#decimal#int                 --
    -- number#decimal#fixed#zero          --
    -- number#decimal#fixed#space         --
    -- number#hex 	                ✓ 	✓ --
    -- number#octal                       --
    -- number#binary 	            ✓ 	✓ --
    -- date#[%Y/%m/%d] 	            ✓ 	✓ --
    -- date#[%m/%d] 	            ✓ 	✓ --
    -- date#[%-m/%-d]                     --
    -- date#[%Y-%m-%d] 	            ✓ 	✓ --
    -- date#[%Y年%-m月%-d日]              --
    -- date#[%Y年%-m月%-d日(%ja)]         --
    -- date#[%H:%M:%S]                    --
    -- date#[%H:%M] 	            ✓ 	✓ --
    -- date#[%ja]                         --
    -- date#[%jA] 	                ✓ 	✓ --
    -- char#alph#small#word 		    ✓ --
    -- char#alph#capital#word 		    ✓ --
    -- char#alph#small#str                --
    -- char#alph#capital#str              --
    -- color#hex 	                ✓ 	✓ --
    -- markup#markdown#header             --
    ----------------------------------------

    dial.config.searchlist.normal = {
        "number#decimal",
        "number#hex",
        "number#binary",
        "date#[%Y/%m/%d]",
    }

    dial.augends["custom#rust_octal_augend"] = {
        desc = "double or halve the number. (1 <-> 2 <-> 4 <-> 8 <-> ...)",
        find = dial.common.find_pattern("0o[0-7]+"),
        add = function(cursor, text, addend)
            local wid = #text
            local n = tonumber(string.sub(text, 3), 8)
            n = n + addend
            if n < 0 then
                n = 0
            end
            text = "0o" .. require("dial.util").tostring_with_base(n, 8, wid - 2, "0")
            cursor = #text
            return cursor, text
        end
    }
    table.insert(dial.config.searchlist.normal, "custom#rust_octal_augend")

    dial.augends["custom#boolean"] = dial.common.enum_cyclic({
        name = "boolean",
        strlist = {"true", "false"},
    })
    table.insert(dial.config.searchlist.normal, "custom#boolean")

    -- local function feedkeys(str)
    --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes(str, true, true, true), "n")
    -- end

    -- local wk = require("which-key")

    -- local normalMappings = {
    --     ["<C-a>"] = { function ()
    --         require("dial").cmd.increment_normal(vim.api.nvim_get_vvar("count"))
    --     end, "" },
    --     ["<C-x>"] = { function ()
    --         require("dial").cmd.increment_normal(-vim.api.nvim_get_vvar("count"))
    --     end, "" },
    -- }
    -- local visualMappings = {
    --     ["<C-a>"] = { function ()
    --         require("dial").cmd.increment_normal(vim.api.nvim_get_vvar("count"))
    --         feedkeys("gv")
    --     end, "" },
    --     ["<C-x>"] = { function ()
    --         require("dial").cmd.increment_normal(-vim.api.nvim_get_vvar("count"))
    --         feedkeys("gv")
    --     end, "" },
    --     ["g<C-a>"] = { function ()
    --         require("dial").cmd.increment_normal(vim.api.nvim_get_vvar("count", nil, true))
    --         feedkeys("gv")
    --     end, "" },
    --     ["g<C-x>"] = { function ()
    --         require("dial").cmd.increment_normal(-vim.api.nvim_get_vvar("count", nil, true))
    --         feedkeys("gv")
    --     end, "" },
    -- }

    -- wk.register(normalMappings, { mode = "n", prefix = "" })
    -- wk.register(visualMappings, { mode = "v", prefix = "" })

    vim.cmd [[
        nmap <C-a> <Plug>(dial-increment)
        nmap <C-x> <Plug>(dial-decrement)
        vmap <C-a> <Plug>(dial-increment)
        vmap <C-x> <Plug>(dial-decrement)
        vmap g<C-a> <Plug>(dial-increment-additional)
        vmap g<C-x> <Plug>(dial-decrement-additional)
    ]]

end

return M
