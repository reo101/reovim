local M = {}

M.config = function()

    local opt = {
        change_directory_command = "cd", -- default: "cd"
        update_on_change = true, -- default: true
        update_on_change_command = "Telescope find_files", -- default: "e ."
        clearjumps_on_change = true, -- default: true
        autopush = false, -- default: false
    }

    require("git-worktree").setup(opt)

    require("telescope").load_extension("git_worktree")
    
    local wk = require("which-key")

    local mappings = {
        g = {
            name ="Git",
            w = {
                name = "Worktrees",
                t = { require("telescope").extensions.git_worktree.git_worktrees, "Telescope" },
                c = { require("telescope").extensions.git_worktree.create_git_worktree, "Create" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
