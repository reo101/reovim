local M = {}

M.config = function()

    vim.g.dashboard_default_executive = "telescope"

    local command = "stty size | cut -d' ' -f2" -- get terminal width
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()   

    local isNarrow = tonumber(result) < 82

    if isNarrow then
        vim.g.dashboard_custom_header = {
            [[       ___           ___           ___      ]],
            [[      /  /\         /  /\         /  /\     ]],
            [[     /  /::\       /  /:/_       /  /::\    ]],
            [[    /  /:/\:\     /  /:/ /\     /  /:/\:\   ]],
            [[   /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\  ]],
            [[  /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\ ]],
            [[  \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/ ]],
            [[   \  \::/~~~~   \  \::/ /:/   \  \:\  /:/  ]],
            [[    \  \:\        \  \:\/:/     \  \:\/:/   ]],
            [[     \  \:\        \  \::/       \  \::/    ]],
            [[      \__\/         \__\/         \__\/     ]],
            [[                                ___         ]],
            [[       ___        ___          /__/\        ]],
            [[      /__/\      /  /\        |  |::\       ]],
            [[      \  \:\    /  /:/        |  |:|:\      ]],
            [[       \  \:\  /__/::\      __|__|:|\:\     ]],
            [[   ___  \__\:\ \__\/\:\__  /__/::::| \:\    ]],
            [[  /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/    ]],
            [[  \  \:\|  |:|     \__\::/  \  \:\          ]],
            [[   \  \:\__|:|     /__/:/    \  \:\         ]],
            [[    \__\::::/      \__\/      \  \:\        ]],
            [[        ~~~~                   \__\/        ]],
        }
    else
        vim.g.dashboard_custom_header = {
            [[      ___           ___           ___                                    ___      ]],
            [[     /  /\         /  /\         /  /\          ___        ___          /__/\     ]],
            [[    /  /::\       /  /:/_       /  /::\        /__/\      /  /\        |  |::\    ]],
            [[   /  /:/\:\     /  /:/ /\     /  /:/\:\       \  \:\    /  /:/        |  |:|:\   ]],
            [[  /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\       \  \:\  /__/::\      __|__|:|\:\  ]],
            [[ /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\ ]],
            [[ \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/ ]],
            [[  \  \::/~~~~   \  \::/ /:/   \  \:\  /:/  \  \:\|  |:|     \__\::/  \  \:\       ]],
            [[   \  \:\        \  \:\/:/     \  \:\/:/    \  \:\__|:|     /__/:/    \  \:\      ]],
            [[    \  \:\        \  \::/       \  \::/      \__\::::/      \__\/      \  \:\     ]],
            [[     \__\/         \__\/         \__\/           ~~~~                   \__\/     ]],
        }
    end

    vim.cmd("let packages = len(globpath('" .. vim.fn.stdpath("data") .. "/site/pack/packer/start', '*', 0, 1))")

    vim.api.nvim_exec(
        [[
        let g:dashboard_custom_footer = ['LuaJIT loaded '..packages..' plugins']
        ]],
        false
    )

    vim.g.dashboard_custom_section = {
        a = {
            description = { "  Find File          " },
            command = "Telescope find_files",
        },
        b = {
            description = { "  Recently Used Files" },
            command = "Telescope oldfiles",
        },
        c = {
            description = { "  Find Word          " },
            command = "Telescope live_grep",
        },
        d = {
            description = { "  Plugins            " },
            command = ":e " .. vim.fn.stdpath("config") .. "/lua/plugins/packages.lua",
        },
        e = {
            description = { "  Neovim Config Files" },
            command = "Telescope find_files cwd=" .. vim.fn.stdpath("config"),
        },    
        f = {
            description = {"  Marks               " },
            command = "Telescope marks",
        },
    }
    
    vim.cmd([[
    augroup Dashboard
        autocmd!
        autocmd FileType dashboard setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs=
        autocmd FileType dashboard set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2
        autocmd FileType dashboard nnoremap <silent> <buffer> q :q<CR>
    augroup END
    ]])

end

return M
