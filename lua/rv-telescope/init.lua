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
            path_display = {
                -- "hidden",
                -- "tail",
                -- "absolute",
                -- "shorten",
            },
            wrap_results = true,
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
            ["ui-select"] = {
                require("telescope.themes").get_cursor({
                    winblend = 10,
                    border = true,
                    previewer = false,
                    shorten_path = false,
                })
            },
            file_browser = {
                theme = "ivy",
                mappings = {
                    ["i"] = {
                        -- your custom insert mode mappings
                    },
                    ["n"] = {
                        -- your custom normal mode mappings
                    },
                },
            },
        },
    }

    require("telescope").setup(opt)

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("gh")
    require("telescope").load_extension("media_files")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("aerial")
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("refactoring")

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local themes = require("telescope.themes")

    local functions = {}

    function functions.find_files()
        if vim.o.columns < 128 then
            require("telescope.builtin").find_files(require("telescope.themes").get_dropdown())
        else
            require("telescope.builtin").find_files()
        end
    end

    function functions.buffer_git_files()
        require("telescope.builtin").git_files(themes.get_dropdown {
            cwd = vim.fn.expand "%:p:h",
            winblend = 10,
            border = true,
            previewer = false,
            shorten_path = false,
        })
    end

    function functions.live_grep()
        require("telescope.builtin").live_grep {
            -- shorten_path = true,
            previewer = false,
            fzf_separator = "|>",
        }
    end

    function functions.grep_prompt()
        require("telescope.builtin").grep_string {
            path_display = { "shorten" },
            search = vim.fn.input "Grep String > ",
        }
    end

    function functions.grep_last_search(opts)
        opts = opts or {}

        -- \<getreg\>\C
        -- -> Subs out the search things
        local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

        opts.path_display = { "shorten" }
        opts.word_match = "-w"
        opts.search = register

        require("telescope.builtin").grep_string(opts)
    end

    function functions.oldfiles()
        -- require("telescope").extensions.frecency.frecency()
        require("telescope.builtin").oldfiles()
    end

    function functions.installed_plugins()
        require("telescope.builtin").find_files {
            cwd = vim.fn.stdpath "data" .. "/site/pack/packer/start/",
        }
    end

    function functions.buffers()
        require("telescope.builtin").buffers {
            shorten_path = false,
        }
    end

    function functions.curbuf()
        local opts = themes.get_dropdown {
            winblend = 10,
            border = true,
            previewer = false,
            shorten_path = false,
        }

        require("telescope.builtin").current_buffer_fuzzy_find(opts)
    end

    function functions.search_all_files()
        require("telescope.builtin").find_files {
            find_command = { "rg", "--no-ignore", "--files" },
        }
    end

    local wk = require("which-key")

    local mappings = {
        f = {
            name = "Find",
            f = { functions.find_files, "Find File" },
            F = { functions.search_all_files, "All Files" },
            r = { functions.oldfiles, "Recent Files" },
            p = { functions.installed_plugins, "Plugins" },
            s = { functions.grep_promp, "Static grep" },
            g = { functions.live_grep, "Live Grep" },
            G = { functions.grep_last_search, "Last Grep" },
            c = { functions.curbuf, "Current Buffer" },
            b = { functions.buffers, "Buffers" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
