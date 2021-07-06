local packer = require("packer")

packer.startup{
    function(use) 
        -- Packer
        use { "wbthomason/packer.nvim" }

        -- Colourscheme
        use { "tanvirtin/monokai.nvim" }

        -- LSP
        use { "neovim/nvim-lspconfig" }

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

        -- DevIcons
        use {
            "kyazdani42/nvim-web-devicons",
            opt = true,
            config = function()
                require("rv-devicons").setup()
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

        -- File Tree
        use { "kyazdani42/nvim-tree.lua" } -- TODO

        -- Better increment/decrement
        use { "monaga/dial.nvim" }

        -- Highlight comments
        use { "tjdevries/vim-inyoface" } -- TODO

    end,
    config = {
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
    },
}
