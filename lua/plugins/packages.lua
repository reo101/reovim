local packer = require("packer")

packer.startup{
    function(use)
        -- Packer
        use { "wbthomason/packer.nvim" }

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
                require("rv-nightfox").config()
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
        use {
            "nvim-telescope/telescope-packer.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
        }
        use {
            "nvim-telescope/telescope-fzf-native.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
            run = "make",
        }
        use {
            "nvim-telescope/telescope-github.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
        }
        use {
            "nvim-telescope/telescope-media-files.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
        }
        use {
            "nvim-telescope/telescope-symbols.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" }
            },
        }

        -- Neorg
        use {
            "vhyrro/neorg",
            requires = {
                { "nvim-lua/plenary.nvim" }
            },
            after = {
                "telescope.nvim",
                "nvim-cmp",
            },
            config = function()
                require("rv-neorg").config()
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
        }
        use {
            "onsails/lspkind-nvim",
        }
        use {
            "nanotee/sqls.nvim",
        }

        -- LuaSnip
        use {
            "L3MON4D3/LuaSnip",
            as = "luasnip",
            config = function()
                -- require("rv-luasnip").config()
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
        }
        use {
            "nvim-treesitter/nvim-treesitter-textobjects",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
        }
        use {
            "mfussenegger/nvim-ts-hint-textobject",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-hint-textobject",
        }
        use {
            "nvim-treesitter/playground",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-playground",
        }
        use {
            "p00f/nvim-ts-rainbow",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-rainbow",
        }
        use {
            "romgrk/nvim-treesitter-context",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
        }
        use {
            "JoosepAlviste/nvim-ts-context-commentstring",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-context-commentstring",
        }
        use {
            "windwp/nvim-ts-autotag",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-autotag",
        }

        -- Cmp
        local cmp_sources = {
            "hrsh7th/cmp-buffer",
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
            event = "InsertEnter",
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

        -- Surround
        use {
            "blackCauldron7/surround.nvim",
            config = function()
                require("rv-surround").config()
            end,
            disable = true,
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
        use { "monaqa/dial.nvim" }

        -- Neogit
        use {
            "TimUntersberger/neogit",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("rv-neogit").config()
            end,
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

        -- Comments
        use {
            "terrortylor/nvim-comment",
            ad = "comments",
            config = function()
                require("rv-comments").config()
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
    },
}
