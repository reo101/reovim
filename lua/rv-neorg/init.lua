local M = {}

M.config = function()

    local opt = {
        -- Tell Neorg what modules to load
        load = {
            ["core.defaults"] = {}, -- Load all the default modules
            ["core.keybinds"] = { -- Configure core.keybinds
                config = {
                    default_keybinds = true, -- Generate the default keybinds
                    neorg_leader = "<leader>o", -- This is the default if unspecified
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
        },
        hook = function()

            local neorg_callbacks = require("neorg.callbacks")

            local wk = require("which-key")

            local mappings = {
                o = {
                    name = "Neorg",
                },
            }

            wk.register(mappings, { prefix = "<leader>" })

            neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)

                keybinds.map_event_to_mode("norg", {
                    n = {
                        { "gtd", "core.norg.qol.todo_items.todo.task_done" },
                        { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
                        { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
                        { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" }
                    },
                }, { silent = true, noremap = true })

                wk.register({
                    ["gt"] = {
                        name = "Task",
                        d = { "Done" },
                        u = { "Undone" },
                        p = { "Pending" },
                    },
                    ["<C-Space>"] = { "Cycle Task" },
                }, { silent = true, noremap = true })

            end)

        end,
    }

    require("neorg").setup(opt)

end

return M
