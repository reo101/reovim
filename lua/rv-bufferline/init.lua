local M = {}

M.config = function()

    local opt = {
        options = {
            -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
            numbers = "both",
            --- @deprecated, please specify numbers as a function to customize the styling
            -- number_style = "superscript" | "subscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
            -- number_style = "",
            close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
            -- NOTE: this plugin is designed with this icon in mind,
            -- and so changing this is NOT recommended, this is intended
            -- as an escape hatch for people who cannot bear it for whatever reason
            indicator_icon = "▎",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            --- name_formatter can be used to change the buffer"s label in the bufferline.
            --- Please note some names can/will break the
            --- bufferline so use this at your discretion knowing that it has
            --- some limitations that will *NOT* be fixed.
            name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
                -- remove extension from markdown files for example
                if buf.name:match("%.md") then
                    return vim.fn.fnamemodify(buf.name, ":t:r")
                end
            end,
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            tab_size = 18,
            -- diagnostics = false | "nvim_lsp" | "coc",
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                return "("..count..")"
            end,
            -- NOTE: this will be called a lot so don"t do any heavy processing here
            -- custom_filter = function(buf_number, buf_numbers)
            --     -- filter out filetypes you don"t want to see
            --     if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
            --         return true
            --     end
            --     -- filter out by buffer name
            --     if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
            --         return true
            --     end
            --     -- filter out based on arbitrary rules
            --     -- e.g. filter out vim wiki buffer from tabline in your work repo
            --     if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
            --         return true
            --     end
            --     -- filter out by it"s index number in list (don't show first buffer)
            --     if buf_numbers[1] ~= buf_number then
            --         return true
            --     end
            -- end,
            -- offsets = {{filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"}},
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align  = "center",
                },
            },
            -- show_buffer_icons = true | false, -- disable filetype icons for buffers
            show_buffer_icons = true,
            -- show_buffer_close_icons = true | false,
            show_buffer_close_icons = true,
            -- show_close_icon = true | false,
            show_close_icon = false,
            -- show_tab_indicators = true | false,
            show_tab_indicators = true,
            -- persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            persist_buffer_sort = true,
            -- -- can also be a table containing 2 custom separators
            -- -- [focused and unfocused]. eg: { '|', '|' }
            -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
            separator_style = "slant",
            -- enforce_regular_tabs = false | true,
            enforce_regular_tabs = false,
            -- always_show_bufferline = true | false,
            always_show_bufferline = true,
            -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
            --   -- add custom logic
            --   return buffer_a.modified > buffer_b.modified
            -- end
            -- sort_by = function(buffer_a, buffer_b)
            --     return buffer_a.modified > buffer_b.modified
            -- end,
        }
    }

    require("bufferline").setup(opt)

    local wk = require("which-key")

    local mappings = {
        b = {
            name = "Buffer",
            ["1"] = { "<Cmd>BufferLineGoToBuffer 1<CR>" , "1" },
            ["2"] = { "<Cmd>BufferLineGoToBuffer 2<CR>" , "2" },
            ["3"] = { "<Cmd>BufferLineGoToBuffer 3<CR>" , "3" },
            ["4"] = { "<Cmd>BufferLineGoToBuffer 4<CR>" , "4" },
            ["5"] = { "<Cmd>BufferLineGoToBuffer 5<CR>" , "5" },
            ["6"] = { "<Cmd>BufferLineGoToBuffer 6<CR>" , "6" },
            ["7"] = { "<Cmd>BufferLineGoToBuffer 7<CR>" , "7" },
            ["8"] = { "<Cmd>BufferLineGoToBuffer 8<CR>" , "8" },
            ["9"] = { "<Cmd>BufferLineGoToBuffer 9<CR>" , "9" },
            s = { "<Cmd>w<CR>", "Save" },
            e = { "<Cmd>e<CR>", "Edit" },
            c = { function(bufnum)
                require("bufdelete").bufdelete(bufnum, true)
            end, "This" },
            m = {
                name = "Mass Close",
                l = { function() require("bufferline").close_in_direction("left") end, "Left" },
                r = { function() require("bufferline").close_in_direction("right") end, "Right" },
                p = { require("bufferline").close_buffer_with_pick, "Pick" },
            },
            h = { require("bufferline").pick_buffer, "Hop" },
            o = {
                name = "Order",
                e = { function() require("bufferline").sort_buffers_by("extension") end, "Extension" },
                d = { function() require("bufferline").sort_buffers_by("directory") end, "Directory" },
                r = { function() require("bufferline").sort_buffers_by("relative_directory") end, "Relative Directory" },
                t = { function() require("bufferline").sort_buffers_by("tabs") end, "Tabs" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    wk.register({
        ["<A-Left>"] = { function() require("bufferline").cycle(-1) end, "Go To Previous Buffer" },
        ["<A-Right>"] = { function() require("bufferline").cycle(1) end, "Go To Next Buffer" },
        ["<A-S-Left>"] = { function() require("bufferline").move(-1) end, " Swap Previous Buffer" },
        ["<A-S-Right>"] = { function() require("bufferline").move(1) end, "Swap Next Buffer" },
    }, { prefix = "" })

end

return M
