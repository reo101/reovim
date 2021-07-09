local M = {}

M.config = function()
    
    opt = {
        ensure_installed = {"cpp", "lua", "javascript", "java", "php", "python", "comment"},
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        rainbow = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<leader>siv",
                scope_incremental = "<leader>sis",
                node_incremental = "<leader>sii",
                node_decremental = "<leader>sid",
            }
        },
        refactor = {
            highlight_definitions = {
                enable = true,
            },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<leader>sr",
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "<leader>sdg",
                    list_definitions = "<leader>sdl",
                },
            },
        },
        textobjects = {
            enable = true,
            disable = {},
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["ae"] = "@block.outer",
                    ["ie"] = "@block.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["is"] = "@statement.inner",
                    ["as"] = "@statement.outer",
                    ["ad"] = "@comment.outer",
                    ["am"] = "@call.outer",
                    ["im"] = "@call.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>ssn"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>ssp"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            lsp_interop = {
                enable = false,
            },
        },
        context = {
            enable = true,
        },
        context_commentstring = {
            enable = true,
        },
        autopairs = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
    }

    require("nvim-treesitter.configs").setup(opt)

    local wk = require("which-key")

    local mappings = {  
        s = {
            name = "TreeSitter",
            i = {
                name = "Incremental Selection",
                v = { "Init selection" },
                s = { "Scope Incremental" },
                i = { "Node Incremental" },
                d = { "Node Decremental" },
            },
            r = { "Smart rename" },
            d = {
                name = "Definitions",
                g = { "Goto definition" },
                l = { "List definitions" },
            },
            s = {
                name = "Swap",
                n = { "Swap next" },
                p = { "Swap previous" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local operatorMappings = {
        a = { name = "around" },
        i = { name = "inside" },
        ["af"] = { "@function.outer" },
        ["if"] = { "@function.inner" },
        ["aC"] = { "@class.outer" },
        ["iC"] = { "@class.inner" },
        ["ac"] = { "@conditional.outer" },
        ["ic"] = { "@conditional.inner" },
        ["ae"] = { "@block.outer" },
        ["ie"] = { "@block.inner" },
        ["al"] = { "@loop.outer" },
        ["il"] = { "@loop.inner" },
        ["is"] = { "@statement.inner" },
        ["as"] = { "@statement.outer" },
        ["ad"] = { "@comment.outer" },
        ["am"] = { "@call.outer" },
        ["im"] = { "@call.inner" },
    }

    wk.register(operatorMappings, { mode = "o", prefix = "" })

    local motionMappings = {
        ["]m"] = { "Next @function.outer start" },
        ["]]"] = { "Next @class.outer start" },
        ["]M"] = { "Next @function.outer end" },
        ["]["] = { "Next @class.outer end" },
        ["[m"] = { "Previous @function.outer start" },
        ["[["] = { "Previous class.outer start" },
        ["[M"] = { "Previous @function.outer end" },
        ["[]"] = { "Previous @class.outer end" },
    }

    wk.register(motionMappings, { mode = "n", prefix = "" })
    wk.register(motionMappings, { mode = "o", prefix = "" })

    local TSHopMappings = {
        m = { function() require('tsht').nodes() end, "TS Hop" },
    }

    wk.register(TSHopMappings, { mode = "o", prefix = "" })
    wk.register(TSHopMappings, { mode = "v", noremap = true, prefix = "" })

end

return M
