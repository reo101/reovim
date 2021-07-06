local packer = require("packer")

packer.startup{function(use) 
	
	-- Packer
	use {"wbthomason/packer.nvim"}

	-- LSP
	use {"neovim/nvim-lspconfig"}

	-- Telescope
	use {
		"nvim-telescope/telescope.nvim",
		requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
	}

	-- Compe
	use {
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require("rv-compe").config()
		end,
	}

end,
config = {
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end
	}
}}
