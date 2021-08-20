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
		max_abbr_width = 50,
		max_kind_width = 50,
		max_menu_width = 50,
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
            neorg = true,
		},
	}

    vim.opt.completeopt = "menuone,preview,noinsert,noselect"
	require("compe").setup(opt)

    _G.cr_complete = function()
        if vim.fn.pumvisible() == 1 then
            return vim.fn["compe#confirm"]({
                keys = "<CR>",
                select = true,
            })
        else
            return vim.fn["compe#confirm"](
                require("nvim-autopairs").autopairs_cr()
            )
        end
    end

    require("which-key").register({
        ["<CR>"] = { "v:lua.cr_complete()" , "CR" }
    }, { mode = "i", expr = true })

end

return M
