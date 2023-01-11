local M = {}

M.config = function()

    local opt = {
        opts = {
            remote = nil, -- force the use of a specific remote
            -- adds current line nr in the url for normal mode
            add_current_line_on_normal_mode = true,
            -- callback for what to do with the url
            action_callback = require("gitlinker.actions").copy_to_clipboard,
            -- print the url after performing the action
            print_url = true,
        },
        callbacks = {
            ["github.com"] = require("gitlinker.hosts").get_github_type_url,
            ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
            ["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
            ["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
            ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
            ["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
            ["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
            ["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
            ["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
            ["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
            ["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url
        },
        mappings = nil
    }

    require("gitlinker").setup(opt)

    local wk = require("which-key")

    for _, mode in ipairs({"n", "v"}) do
        wk.register({
            g = {
                name = "Git",
                b = { function()
                    require("gitlinker").get_buf_range_url(mode, {action_callback = require("gitlinker.actions").open_in_browser})
                end, "Browse" },
            },
        }, { mode = mode, prefix = "<leader>" })
    end

end

return M
