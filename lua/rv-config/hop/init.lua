local M = {}

M.config = function()

    local opt = {
        -- you can configure Hop the way you like here; see :h hop-config
        keys = "etovxqpdygfblzhckisuran"
    }

    require("hop").setup(opt)

    local wk = require("which-key")

    local mappings = {
        h = {
            name = "Hop",
            ["1"] = { function() require("hop").hint_char1() end, "1 Char" },
            ["2"] = { function() require("hop").hint_char2() end, "2 Chars" },
            ["l"] = { function() require("hop").hint_lines_skip_whitespace() end, "Line (no whitespace)" },
            ["w"] = { function() require("hop").hint_words() end, "Words" },
            ["/"] = { function() require("hop").hint_patterns() end, "Pattern" },
        },
    }
    
    wk.register(mappings, { prefix = "<leader>" })

end

return M
