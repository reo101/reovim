local M = {}

M.config = function()

    local opt = {
        -- Tell Neorg what modules to load
        load = {
            ["core.defaults"] = {}, -- Load all the default modules
            ["core.keybinds"] = { -- Configure core.keybinds
                config = {
                    default_keybinds = false, -- Generate the default keybinds
                    neorg_leader = "<leader>o", -- This is the default if unspecified

                    hook = function(keybinds)
                        local mappings = {}

                        mappings["gt"] = { name = "Task" }

                        keybinds.map("norg", "n", "gtd", "core.norg.qol.todo_items.task_done")
                        mappings["gtd"] = { "Done" }

                        keybinds.map("norg", "n", "gtu", "core.norg.qol.todo_items.task_undone")
                        mappings["gtu"] = { "Undone" }

                        keybinds.map("norg", "n", "gtp", "core.norg.qol.todo_items.task_pending")
                        mappings["gtp"] = { "Pending" }

                        keybinds.map("norg", "n", "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle")
                        mappings["<C-Space>"] = { "Cycle Task" }

                        local wk = require("which-key")

                        wk.register(mappings, { prefix = "" })
                    end,
                },
            },
            ["core.norg.concealer"] = {}, -- Allows for use of icons
            ["core.norg.dirman"] = { -- Manage your directories with Neorg
                config = {
                    workspaces = {
                        Notes = "~/Notes",
                    },
                },
            },
            ["core.norg.completion"] = { -- Enable nvim-cmp completion
                config = {
                    engine = "nvim-cmp",
                },
            },
            ["core.integrations.telescope"] = {}, -- Enable the telescope module
            ["core.norg.esupports.metagen"] = {
                config = {
                    type = "auto",
                }
            }, -- Enable the metagen module
            ["core.presenter"] = {
                config = {
                    zen_mode = "truezen",
                }
            }, -- Enable the presenter module
        },
    }

    require("neorg").setup(opt)

end

return M
