local packer = require("packer")

packer.startup{
    function(use)
        -- Packer
        use { "wbthomason/packer.nvim" }

        -- Impatient
        use{ "lewis6991/impatient.nvim" }

        -- Colourscheme
        use { "tanvirtin/monokai.nvim" }
        use {
            "sainnhe/sonokai",
            config = function()
                -- require("rv-sonokai").config()
            end,
        }
        use {
            "EdenEast/nightfox.nvim",
            config = function()
                -- require("rv-nightfox").config()
            end,
        }
        use {
            "folke/tokyonight.nvim",
            config = function()
                require("rv-tokyonight").config()
            end,
        }

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/popup.nvim" },
                { "nvim-lua/plenary.nvim" }
            },
            config = function()
                require("rv-telescope").config()
            end,
        }
        local telescope_plugins = {
            "nvim-telescope/telescope-packer.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-github.nvim",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-symbols.nvim",
        }
        for _, telescope_plugin in ipairs(telescope_plugins) do
            local opt = {
                telescope_plugin,
                requires = {
                    { "nvim-telescope/telescope.nvim" }
                },
            }
            use(opt)
        end

        -- Neorg
        use {
            "vhyrro/neorg",
            branch = "unstable",
            requires = {
                { "hrsh7th/nvim-cmp" },
                { "nvim-lua/plenary.nvim" },
                { "vhyrro/neorg-telescope" },
            },
            after = {
                "telescope.nvim",
                "nvim-cmp",
            },
            config = function()
                require("rv-neorg").config()
            end,
        }
        use {
            "vhyrro/neorg-telescope",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
        }

        -- Markdown Preview
        use {
            "iamcco/markdown-preview.nvim",
            run = vim.fn["mkdp#util#install"],
            config = function ()
                require("rv-mdpreview").config()
            end
        }
        use {
            "jghauser/follow-md-links.nvim",
            requires = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("rv-mdlinks").config()
            end
        }

        -- Silicon
        use {
            "segeljakt/vim-silicon",
            config = function()
                require("rv-silicon").config()
            end,
        }

        -- Which-key
        use {
            "folke/which-key.nvim",
            config = function()
                require("rv-whichkey").config()
                require("rv-whichkey.presets").config()
            end,
        }

        -- Dashboard
        use {
            "glepnir/dashboard-nvim",
            as = "dashboard",
            config = function()
                require("rv-dashboard").config()
            end,
        }

        -- TrueZen
        use {
            "Pocco81/TrueZen.nvim",
            as = "zen",
            config = function()
                require("rv-zen").config()
            end,
            disable = true, -- TODO
        }

        -- Lualine
        use {
            'hoob3rt/lualine.nvim',
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
            config = function()
                require("rv-lualine").config()
            end,
        }
        use {
            "SmiteshP/nvim-gps",
            requires = { "nvim-treesitter/nvim-treesitter" },
        }

        -- Barbar
        use {
            "romgrk/barbar.nvim",
            as = "barbar",
            config = function()
                require("rv-barbar").config()
            end,
        }

        -- Auto-session
        use {
            "rmagatti/auto-session",
            as = "autosession",
            config = function()
                require("rv-autosession").config()
            end,
            disable = true, -- TODO
        }

        -- DevIcons
        use {
            "kyazdani42/nvim-web-devicons",
            config = function()
                require("rv-devicons").config()
            end,
        }
        use {
            "yamatsum/nvim-nonicons",
            requires = { "kyazdani42/nvim-web-devicons" },
            after = { "nvim-web-devicons" },
            disable = true,
        }

        -- Colourizer
        use {
            "norcalli/nvim-colorizer.lua",
            as = "colourizer",
            config = function()
                require("rv-colourizer").config()
            end,
        }

        -- Discord Rich Presence
        use {
            "andweeb/presence.nvim",
            as = "presence",
            config = function()
                require("rv-presence").config()
            end,
        }

        -- Cheat.sh
        use {
            "RishabhRD/nvim-cheat.sh",
            requires = { "RishabhRD/popfix" },
            config = function()
                require("rv-cheatsh").config()
            end,
        }

        -- Notify
        use {
            "rcarriga/nvim-notify",
            as = "notify",
            after = { "sonokai" },
            config = function()
                require("rv-notify").config()
            end,
        }

        -- LSP
        use { "neovim/nvim-lspconfig" }
        use {
            "folke/trouble.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            conqig = function()
                require("rv-lsp.trouble").config()
            end,
        }
        use {
            "ray-x/lsp_signature.nvim",
        }
        use {
            "kosayoda/nvim-lightbulb",
            config = function()
                require("rv-lsp.lightbulb").config()
            end,
            disable = true, -- TODO
        }
        use {
            "onsails/lspkind-nvim",
        }
        use {
            "jose-elias-alvarez/null-ls.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "neovim/nvim-lspconfig",
            },
        }
        use {
            "nanotee/sqls.nvim",
        }
        use {
            "simrat39/symbols-outline.nvim",
            as = "outline",
            config = function()
                require("rv-outline").config()
            end,
        }
        use {
            "Saecki/crates.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-crates").config()
            end,
        }
        use {
            "weilbith/nvim-code-action-menu",
            as = "code-action-menu",
            cmd = "CodeActionMenu",
        }
        use {
            "NTBBloodbath/rest.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-rest").config()
            end,
        }
        use {
            "simrat39/rust-tools.nvim",
            config = function()
                require("rv-lsp.langs.rust-tools").config()
            end,
        }

        -- DAP
        use {
            "mfussenegger/nvim-dap",
            config = function()
                require("rv-dap").config()
            end,
        }
        use {
            "theHamsta/nvim-dap-virtual-text",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require("rv-dap.virttext").config()
            end,
        }
        use {
            "rcarriga/nvim-dap-ui",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require("rv-dap.dapui").config()
            end,
        }

        -- LuaSnip
        use {
            "L3MON4D3/LuaSnip",
            as = "luasnip",
            config = function()
                require("rv-luasnip").config()
            end,
        }
        use {
            "rafamadriz/friendly-snippets",
        }

        -- Shade
        use {
            "sunjon/shade.nvim",
            config = function()
                require("rv-shade").config()
            end,
            disable = true,
        }

        -- Transparency
        use {
            "xiyaowong/nvim-transparent",
            as = "nvim-transparency",
            config = function()
                require("rv-transparency").config()
            end,
        }

        -- CursorHold
        use {
            "antoinemadec/FixCursorHold.nvim",
            as = "cursorhold",
            config = function()
                require("rv-cursorhold").config()
            end,
        }

        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("rv-treesitter").config()
            end,
        }
        local treesitter_plugins = {
            {"nvim-treesitter/nvim-treesitter-textobjects", { as = "treesitter-textobjects",}},
            {"mfussenegger/nvim-ts-hint-textobject", { as = "treesitter-hint-textobject", }},
            {"nvim-treesitter/playground", { as = "treesitter-playground", }},
            {"p00f/nvim-ts-rainbow", { as = "treesitter-rainbow", }},
            {"romgrk/nvim-treesitter-context", { as = "treesitter-context", config = function() require("rv-treesitter.context").config() end, }},
            {"JoosepAlviste/nvim-ts-context-commentstring", { as = "treesitter-context-commentstring", }},
            {"windwp/nvim-ts-autotag", { as = "treesitter-autotag", }},
        }
        for _, treesitter_plugin in ipairs(treesitter_plugins) do
            local opt = {
                treesitter_plugin[1],
                requires = {
                    { "nvim-treesitter/nvim-treesitter" }
                },
            }
            opt = vim.tbl_deep_extend("force", treesitter_plugin[2], opt)
            use(opt)
        end

        -- Cmp
        local cmp_sources = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "andersevenrud/compe-tmux",
            "kdheepak/cmp-latex-symbols",
        }
        use {
            "hrsh7th/nvim-cmp",
            -- event = "InsertEnter",
            requires = cmp_sources,
            config = function()
                require("rv-cmp").config()
            end,
        }
        for _, cmp_source in ipairs(cmp_sources) do
            local opt = {
                cmp_source,
                after = { "nvim-cmp" },
                requires = {
                    { "hrsh7th/nvim-cmp" },
                },
            }
            if cmp_source == "compe-tmux" then
                opt = vim.tbl_deep_extend("force", {
                    branch = "cmp",
                }, opt)
            end

            use(opt)
        end
        use {
            "windwp/nvim-autopairs",
            after = { "nvim-cmp" },
            config = function()
                require("rv-autopairs").config()
            end,
        }

        -- Hop
        use {
            "phaazon/hop.nvim",
            as = "hop",
            config = function()
                require("rv-hop").config()
            end,
        }

        -- HLSlens
        use {
            "kevinhwang91/nvim-hlslens",
            config = function()
                require("rv-hlslens").config()
            end,
        }

        -- Surround
        use {
            "blackCauldron7/surround.nvim",
            config = function()
                require("rv-surround").config()
            end,
        }

        -- Navigator
        use {
            "numToStr/Navigator.nvim",
            as = "navigator",
            config = function()
                require("rv-navigator").config()
            end
        }

        -- File Tree
        use {
            "kyazdani42/nvim-tree.lua",
            config = function()
                require("rv-tree").config()
            end,
        }

        -- Better increment/decrement
        use {
            "monaqa/dial.nvim",
            config = function()
                require("rv-dial").config()
            end,
        }

        -- Neogit
        use {
            "TimUntersberger/neogit",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("rv-neogit").config()
            end,
        }
        use {
            "sindrets/diffview.nvim",
            config = function ()
                require("rv-diffview").config()
            end
        }
        use {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim"
            },
            config = function()
                require("rv-gitsigns").config()
            end,
        }
        use {
            "ThePrimeagen/git-worktree.nvim",
            requires = {
                "nvim-treesitter/nvim-treesitter",
            },
            config = function()
                require("rv-gitworktrees").config()
            end,
        }
        use {
            "pwntester/octo.nvim",
            requires = {
                { "kyazdani42/nvim-web-devicons", opt = true, },
            },
            config = function()
                require("rv-octo").config()
            end,
        }
        use {
            "ruifm/gitlinker.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("rv-gitlinker").config()
            end,
        }

        -- Comments
        use {
            'numToStr/Comment.nvim',
            as = "comments",
            config = function()
                require("rv-comments").config()
            end,
        }
        use {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("rv-todocomments").config()
            end,
        }

        -- Numbertoggle
        use { "jeffkreeftmeijer/vim-numbertoggle" }

        -- Highlight comments
        use { "tjdevries/vim-inyoface" } -- TODO

        -- Auto mkdir -p
        use {
            "jghauser/mkdir.nvim",
            config = function()
                require("mkdir")
            end,
        }

        use {
            "famiu/bufdelete.nvim",
            config = function()
                require("rv-bufdelete").config()
            end,
            disable = true, -- TODO
        }

        -- BufResize
        use({
            "kwkarlwang/bufresize.nvim",
            config = function()
                require("rv-bufresize").config()
            end,
        })

        -- Stabilize
        use {
            "luukvbaal/stabilize.nvim",
            config = function()
                require("rv-stabilize").config()
            end
        }

        -- Spellcheck
        use {
            "lewis6991/spellsitter.nvim",
            config = function()
                require("rv-spellsitter").config()
            end,
        }

        -- Reload
        use {
            "famiu/nvim-reload",
            config = function()
                require("rv-reload").config()
            end,
        }

        -- Quickfix List
        use {
            "kevinhwang91/nvim-bqf",
            config = function()
                require("rv-betterquickfix").config()
            end,
        }

        -- Indentline
        use {
            "lukas-reineke/indent-blankline.nvim",
            as = "indentline",
            config = function()
                require("rv-indentline").config()
            end,
        }

        -- Collaborative Editing
        use { "jbyuki/instant.nvim" } -- TODO username

        -- Beacon
        use {
            "edluffy/specs.nvim",
            as = "beacon",
            config = function()
                require("rv-beacon").config()
            end,
        }

    end,
    config = {
        profile = {
            enable = true,
            threshold = 1,
        },
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
        compile_path = vim.fn.stdpath("config").."/lua/packer_compiled.lua",
    },
}
