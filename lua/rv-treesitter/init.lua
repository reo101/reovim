local M = {}

M.config = function()
    local opt = {
        ensure_installed = {
            "cpp",
            "lua",
            "javascript",
            "java",
            "php",
            "python",
            "html",
            "norg",
            "norg_meta",
            "norg_table",
            "markdown",
            "comment",
        },
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
            },
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
                    ["ar"] = "@parameter.outer",
                    ["ir"] = "@parameter.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>ssnc"] = "@class.outer",
                    ["<leader>ssnf"] = "@function.outer",
                    ["<leader>ssnp"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>sspc"] = "@class.outer",
                    ["<leader>sspf"] = "@function.outer",
                    ["<leader>sspp"] = "@parameter.inner",
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
            filetypes = {
                "html",
                "javascript",
                "javascriptreact",
                "markdown",
                "svelte",
                "typescriptreact",
                "vue",
                "xml",
            },
            skip_tags = {
                "area",
                "base",
                "br",
                "col",
                "command",
                "embed",
                "hr",
                "img",
                "input",
                "keygen",
                "link",
                "menuitem",
                "meta",
                "param",
                "slot",
                "source",
                "track",
                "wbr",
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<cr>",
                show_help = "?",
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
    }

    require("nvim-treesitter.install").prefer_git = true

    require("nvim-treesitter.parsers").get_parser_configs().http = {
        install_info = {
            url = "https://github.com/NTBBloodbath/tree-sitter-http",
            files = { "src/parser.c" },
            branch = "main",
        },
    }

    require("nvim-treesitter.parsers").get_parser_configs().norg_meta = {
        install_info = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
            files = { "src/parser.c" },
            branch = "main",
        },
    }

    require("nvim-treesitter.parsers").get_parser_configs().norg_table = {
        install_info = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
            files = { "src/parser.c" },
            branch = "main",
        },
    }

    -- require("nvim-treesitter.parsers").get_parser_configs().markdown = {
    --     install_info = {
    --         url = "https://github.com/ikatyang/tree-sitter-markdown",
    --         files = {"src/parser.c", "src/scanner.cc"}
    --     },
    --     filetype = "markdown",
    -- }

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
                n = {
                    name = "Swap next",
                    c = { "Class" },
                    f = { "Function" },
                    p = { "Parameter" },
                },
                p = {
                    name = "Swap previous",
                    c = { "Class" },
                    f = { "Function" },
                    p = { "Parameter" },
                },
            },
        },
        t = {
            name = "Toggle",
            s = {
                name = "TreeSitter",
                c = { require("treesitter-context").toggleEnabled, "Context" },
                h = { "<Cmd>TSBufToggle highlight<CR>", "Highlighting" },
                r = { "<Cmd>TSBufToggle rainbow<CR>", "Rainbow Parenthesis" },
                p = { "<Cmd>TSBufToggle autopairs<CR>", "Autopairs" },
                t = { "<Cmd>TSBufToggle autotag<CR>", "Autotags" },
                g = { "<Cmd>TSPlaygroundToggle<CR>", "PlayGround" },
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
        ["ar"] = { "@parameter.outer" },
        ["ir"] = { "@parameter.inner" },
    }

    wk.register(operatorMappings, { mode = "o", prefix = "" })

    local motionMappings = {
        ["]m"] = { "Next @function.outer start" },
        ["]]"] = { "Next @class.outer start" },
        ["]M"] = { "Next @function.outer end" },
        ["]["] = { "Next @class.outer end" },
        ["[m"] = { "Previous @function.outer start" },
        ["[["] = { "Previous @class.outer start" },
        ["[M"] = { "Previous @function.outer end" },
        ["[]"] = { "Previous @class.outer end" },
    }

    wk.register(motionMappings, { mode = "n", prefix = "" })
    wk.register(motionMappings, { mode = "o", prefix = "" })

    local TSHopMappings = {
        m = { require("tsht").nodes, "TS Hop" },
    }

    wk.register(TSHopMappings, { mode = "o", prefix = "" })
    wk.register(TSHopMappings, { mode = "v", noremap = true, prefix = "" })
end

return M
