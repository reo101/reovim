local M = {}

M.config = function()

	opt = {
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
			luasnip = false,
		},
	}

	require("compe").setup(opt)

end

return M
