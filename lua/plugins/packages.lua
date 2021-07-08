local packer = require("packer")

packer.startup{
    function(use) 
        -- Packer
        use { "wbthomason/packer.nvim" }

        -- Colourscheme
        use { "tanvirtin/monokai.nvim" }
        use { "sainnhe/sonokai" }

        -- LSP
        use { "neovim/nvim-lspconfig" }
        use { "kabouzeid/nvim-lspinstall" }

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

        -- Auto-session
        use {
            "rmagatti/auto-session",
            as = "autosession",
            config = function()
                require("rv-autosession").config()
            end,
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
            requires = {"kyazdani42/nvim-web-devicons"},
            after = { "nvim-web-devicons" },
        }

        -- Shade
        use {
            "sunjon/shade.nvim",
            config = function()
                require("rv-shade").config()
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
        }
        use {
            "windwp/nvim-ts-autotag",
            requires = {
                { "nvim-treesitter/nvim-treesitter" }
            },
            as = "nvim-treesitter-autotag",
        }

        -- Compe
        use {
            "hrsh7th/nvim-compe",
            event = "InsertEnter",
            after = { "compe-latex-symbols" },
            config = function()
                require("rv-compe").config()
            end,
        }
        use {
            "GoldsteinE/compe-latex-symbols",
            requires = {
                { "hrsh7th/nvim-compe" }
            },
        }
        use {
            "windwp/nvim-autopairs",
            after = { "nvim-compe" },
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

        -- File Tree
        use { "kyazdani42/nvim-tree.lua" } -- TODO

        -- Better increment/decrement
        use { "monaqa/dial.nvim" }

        -- Neogit
        use {
            "TimUntersberger/neogit",
            requires = "nvim-lua/plenary.nvim",
            config = function() -- TODO
                require("neogit").setup()
            end,
        }

        -- Kommentary
        use {
            "b3nj5m1n/kommentary",
            config = function()
                require("rv-kommentary").config()
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

        -- Cursorline
        use { "yamatsum/nvim-cursorline" }

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
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
    },
}
