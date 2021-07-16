local M = {}

M.config = function()

    vim.g.bufferline = {
        animation = true,
        auto_hide = true,
        tabpages = true,
        closable = false,
        clickable = true,
        icons = true, -- TODO
        icon_custom_colors = false,
        icon_separator_active = "▎",
        icon_separator_inactive = "▎",
        icon_close_tab = "",
        icon_close_tab_modified = "●",
        maximum_padding = 4,
        maximum_length = 30,
        semantic_letters = true,
        letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
        no_name_title = nil,
    }

    local wk = require("which-key")

    local mappings = {
        b = {
            name = "Buffer",
            p = { "<Cmd>BufferPrevious<CR>" , "Previous" },
            n = { "<Cmd>BufferNext<CR>" , "Next" },
            ["<lt>"] = { "<Cmd>BufferMovePrevious<CR>" , "Swap Previous" },
            [">"] = { "<Cmd>BufferMoveNext<CR>" , "Swap Next" },
            ["1"] = { "<Cmd>BufferGoto 1<CR>" , "1" },
            ["2"] = { "<Cmd>BufferGoto 2<CR>" , "2" },
            ["3"] = { "<Cmd>BufferGoto 3<CR>" , "3" },
            ["4"] = { "<Cmd>BufferGoto 4<CR>" , "4" },
            ["5"] = { "<Cmd>BufferGoto 5<CR>" , "5" },
            ["6"] = { "<Cmd>BufferGoto 6<CR>" , "6" },
            ["7"] = { "<Cmd>BufferGoto 7<CR>" , "7" },
            ["8"] = { "<Cmd>BufferGoto 8<CR>" , "8" },
            ["9"] = { "<Cmd>BufferLast<CR>" , "Last" },
            c = { "<Cmd>BufferClose", "Close" },
            m = {
                name = "Mass Close",
                l = { "<Cmd>BufferCloseBuffersLeft<CR>", "Left" },
                r = { "<Cmd>BufferCloseBuffersRight<CR>", "Right" },
                a = { "<Cmd>BufferCloseAllButCurrent<CR>", "All (but current)" },
            },
            h = { "<Cmd>BufferPick<CR>" , "Hop" },
            s = {
                name = "Sort",
                d = { "<Cmd>BufferOrderByDirectory<CR>" , "By Directory"},
                l = { "<Cmd>BufferOrderByLanguage<CR>" , "By Language"},
            }
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
