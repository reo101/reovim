local M = {}

M.config = function()

    local opt = {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "│",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                hl = "GitSignsChange",
                text = "│",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                hl = "GitSignsDelete",
                text = "_",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
        },
        numhl = false,
        linehl = false,
        keymaps = {
            noremap = true,
            buffer = true,

            ["n ]c"] = { expr = true, '&diff ? "]c" : "<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>"'},
            ["n [c"] = { expr = true, '&diff ? "[c" : "<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>"'},
        },
        watch_index = {
            interval = 1000,
            follow_files = true
        },
        current_line_blame = false,
        current_line_blame_delay = 1000,
        current_line_blame_position = "eol",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        use_decoration_api = true,
        use_internal_diff = true,  -- If luajit is present
    }

    require("gitsigns").setup(opt)

    local wk = require("which-key")
    
            -- ["]c"] = { expr = true, "&diff ? "]c" : "<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>""},
            -- ["n [c"] = { expr = true, "&diff ? "[c" : "<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>""},
    local mappings = {
        g = {
            name = "Git",
            h = {
                name = "Hunks",
                s = { function() require("gitsigns").stage_hunk() end, "Stage Hunk" },
                u = { function() require("gitsigns").undo_stage_hunk() end, "Undo Stage Hunk" },
                r = { function() require("gitsigns").reset_hunk() end, "Reset Hunk" },
                R = { function() require("gitsigns").reset_buffer() end, "Reset Buffer" },
                p = { function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
                b = { function() require("gitsigns").blame_line(true) end, "Blame Line" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local visualMappings = {
        ["hs"] = { function() require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "" },
        ["hr"] = { function() require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "" },
    }

    wk.register(visualMappings, { mode = "v", prefix = "<leader>" })

    local operatorMappings = {
        i = { "inside" },
        ["ih"] = { function() require"gitsigns.actions".select_hunk() end, "" },
    }

    wk.register(operatorMappings, { mode = "o", prefix = "<leader>" })
    wk.register(operatorMappings, { mode = "x", prefix = "<leader>" })

end

return M
