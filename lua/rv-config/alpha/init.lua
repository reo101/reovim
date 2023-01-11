local M = {}

M.config = function()

    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local function header()
        local width = vim.o.columns

        local squishy = false

        if width < 52 then
            return {
                [[      ___           ___           ___      ]],
                [[     /  /\         /  /\         /  /\     ]],
                [[    /  /::\       /  /:/_       /  /::\    ]],
                [[   /  /:/\:\     /  /:/ /\     /  /:/\:\   ]],
                [[  /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\  ]],
                [[ /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\ ]],
                [[ \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/ ]],
                [[  \  \::/~~~~   \  \::/ /:/   \  \:\  /:/  ]],
                [[   \  \:\        \  \:\/:/     \  \:\/:/   ]],
                [[    \  \:\        \  \::/       \  \::/    ]],
                [[     \__\/         \__\/         \__\/     ]],
                [[                               ___         ]],
                [[      ___        ___          /__/\        ]],
                [[     /__/\      /  /\        |  |::\       ]],
                [[     \  \:\    /  /:/        |  |:|:\      ]],
                [[      \  \:\  /__/::\      __|__|:|\:\     ]],
                [[  ___  \__\:\ \__\/\:\__  /__/::::| \:\    ]],
                [[ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/    ]],
                [[ \  \:\|  |:|     \__\::/  \  \:\          ]],
                [[  \  \:\__|:|     /__/:/    \  \:\         ]],
                [[   \__\::::/      \__\/      \  \:\        ]],
                [[       ~~~~                   \__\/        ]],
            }
        elseif width < 82 then
            if squishy then
                return {
                    [[      ___           ___           ___               ]],
                    [[     /  /\         /  /\         /  /\              ]],
                    [[    /  /::\       /  /:/_       /  /::\             ]],
                    [[   /  /:/\:\     /  /:/ /\     /  /:/\:\            ]],
                    [[  /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\           ]],
                    [[ /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\ ___      ]],
                    [[ \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /://__/\     ]],
                    [[  \  \::/~~~~___\  \::/ /:/___\  \:\  /:/|  |::\    ]],
                    [[   \  \:\   /__/\\  \:\/://  /\\  \:\/:/ |  |:|:\   ]],
                    [[    \  \:\  \  \:\\  \:://  /:/ \  \::/__|__|:|\:\  ]],
                    [[     \__\/   \  \:\\__\//__/::\  \__\//__/::::| \:\ ]],
                    [[         ___  \__\:\    \__\/\:\__    \  \:\~~\__\/ ]],
                    [[        /__/\ |  |:|       \  \:\/\    \  \:\       ]],
                    [[        \  \:\|  |:|        \__\::/     \  \:\      ]],
                    [[         \  \:\__|:|        /__/:/       \  \:\     ]],
                    [[          \__\::::/         \__\/         \__\/     ]],
                    [[              ~~~~                                  ]],
                }
            else
                return {
                    [[      ___           ___           ___               ]],
                    [[     /  /\         /  /\         /  /\              ]],
                    [[    /  /::\       /  /:/_       /  /::\             ]],
                    [[   /  /:/\:\     /  /:/ /\     /  /:/\:\            ]],
                    [[  /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\           ]],
                    [[ /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\          ]],
                    [[ \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/ ___      ]],
                    [[  \  \::/~~~~   \  \::/ /:/   \  \:\  /:/ /__/\     ]],
                    [[   \  \:\    ___ \  \:\/:/ ___ \  \:\/:/ |  |::\    ]],
                    [[    \  \:\  /__/\ \  \::/ /  /\ \  \::/  |  |:|:\   ]],
                    [[     \__\/  \  \:\ \__\/ /  /:/  \__\/ __|__|:|\:\  ]],
                    [[             \  \:\     /__/::\       /__/::::| \:\ ]],
                    [[         ___  \__\:\    \__\/\:\__    \  \:\~~\__\/ ]],
                    [[        /__/\ |  |:|       \  \:\/\    \  \:\       ]],
                    [[        \  \:\|  |:|        \__\::/     \  \:\      ]],
                    [[         \  \:\__|:|        /__/:/       \  \:\     ]],
                    [[          \__\::::/         \__\/         \__\/     ]],
                    [[              ~~~~                                  ]],
                }
            end
        else
            return {
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
    end

    local function footer()
        vim.cmd("let plugins_count = len(globpath('" .. vim.fn.stdpath("data") .. "/site/pack/packer/start', '*', 0, 1))")

        local plugins_count = vim.g.plugins_count
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = ("   v" .. version.major .. "." .. version.minor .. "." .. version.patch)

        return {
            (datetime .. "   " .. plugins_count .. " plugins" .. nvim_version_info)
        }
    end

    -- Set header
    dashboard.section.header.val = header()

    -- Set footer
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "Constant"

    -- Set menu
    dashboard.section.buttons.val = {
        dashboard.button("<Leader>ff", "  Find File"),
        dashboard.button("<Leader>fr", "  Recent Files"),
        dashboard.button("<Leader>fg", "  Find Word"),
        -- dashboard.button("<Leader>ps", "  Update plugins"),
        dashboard.button("q", "  Quit", ":qa<CR>")
    }

    alpha.setup(dashboard.opts)

    vim.cmd([[
        augroup Alpha
            autocmd!
            autocmd FileType alpha \
                setlocal nofoldenable
            autocmd FileType alpha \
                nnoremap <silent> <buffer> q :q<CR>
            autocmd FileType alpha \
                autocmd VimResized * lua require("rv-alpha").config()
        augroup END
    ]])
end

return M
