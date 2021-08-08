local M = {}

M.config = function()

	local opt = {
		enabled = true,
		autocomplete = true,
		debug = false,
		min_length = 2, --TODO
		preselect = "enable",
		throttle_time = 80,
		source_timeout = 200,
		resolve_timeout = 800,
		incomplete_delay = 400,
		max_abbr_width = 100,
		max_kind_width = 100,
		max_menu_width = 100,
		documentation = true,

		source = { --TODO kinds/emojis
			path = true,
			buffer = true,
			calc = true,
			nvim_lsp = true,
			nvim_lua = true,
			vsnip = false,
			ultisnips = false,
			luasnip = true,
            latex_symbols = true,
		},
	}

    vim.opt.completeopt = "menuone,preview,noinsert,noselect"
	require("compe").setup(opt)

    vim.api.nvim_set_keymap("i", "<CR>", [[ pumvisible() ? compe#confirm({ "keys": "<CR>", "select": v:true }) : compe#confirm(luaeval('require("nvim-autopairs").autopairs_cr()'))]], { expr = true })

end

return M
