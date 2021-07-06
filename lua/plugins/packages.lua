local packer = require("packer")

packer.startup{
    function(use) 
        -- Packer
        use {"wbthomason/packer.nvim"}

        -- Colourscheme

        use {"tanvirtin/monokai.nvim"}

        -- LSP
        use {"neovim/nvim-lspconfig"}

        -- Telescope
        use {
            "nvim-telescope/telescope.nvim", -- TODO
            requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
        }
        use {
            "nvim-telescope/telescope-packer.nvim"
        }
        use {
            "nvim-telescope/telescope-fzf-native.nvim"
        }
        use {
            "nvim-telescope/telescope-github.nvim"
        }
        use {
            "nvim-telescope/telescope-symbols.nvim"
        }

        -- Treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
        }
        use {
            "nvim-treesitter/nvim-treesitter-textobjects",
        }
        use {
            "nvim-treesitter/playground",
            as = "nvim-treesitter-playground",
        }
        use {
            "p00f/nvim-ts-rainbow",
            as = "nvim-treesitter-rainbow",
        }

        -- Compe
        use {
            "hrsh7th/nvim-compe",
            event = "InsertEnter",
            config = function()
                require("rv-compe").config()
            end,
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
            end
        }
    }
}
