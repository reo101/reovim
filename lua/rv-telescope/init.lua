local M = {}

M.config = function()

    local opt = {
        defaults = {
            -- vimgrep_arguments = {
                -- 'rg',
                -- '--color=never',
                -- '--no-heading',
                -- '--with-filename',
                -- '--line-number',
                -- '--column',
                -- '--smart-case'
            -- },
            -- prompt_prefix = "> ",
            -- selection_caret = "> ",
            -- entry_prefix = "  ",
            -- initial_mode = "insert",
            -- selection_strategy = "reset",
            -- sorting_strategy = "descending",
            -- layout_strategy = "horizontal",
            -- layout_config = {
            --     horizontal = {
            --         mirror = false,
            --     },
            --     vertical = {
            --         mirror = false,
            --     },
            -- },
            -- file_sorter =  require'telescope.sorters'.get_fuzzy_file,
            -- file_ignore_patterns = {},
            -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
            -- shorten_path = true,
            winblend = 20,
            -- border = {},
            borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            color_devicons = true,
            -- use_less = true,
            -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
            -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

            -- -- Developer configurations: Not meant for general override
            -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
            mappings = {
                i = {
                    ["<C-s>"] = require("trouble.providers.telescope").open_with_trouble,
                }
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = false, -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            media_files = {
                -- filetypes whitelist
                -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                filetypes = {},
                -- find_cmd = "rg" -- find command (defaults to `fd`)
            },
        },
    }

    require("telescope").setup(opt)

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('gh')
    require('telescope').load_extension('media_files')

    local functions = {}
    functions.find_files = function()
        if vim.o.columns < 128 then
            require("telescope.builtin").find_files(require("telescope.themes").get_dropdown())
        else
            require("telescope.builtin").find_files()
        end
    end

    local wk = require("which-key")

    local mappings = {
        f = {
            name = "Files",
            f = { functions.find_files, "Find File" },
            r = { "<Cmd>Telescope oldfiles<CR>", "Open Recent File" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
