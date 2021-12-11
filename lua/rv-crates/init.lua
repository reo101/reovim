local M = {}

M.config = function()

    local opt = {
        smart_insert = true, -- try to be smart about inserting versions
        avoid_prerelease = true, -- don"t select a prerelease if the requirement does not have a suffix
        autoload = true, -- automatically run update when opening a Cargo.toml
        autoupdate = true, -- automatically update when editing text
        loading_indicator = true, -- show a loading indicator while fetching crate versions
        date_format = "%Y-%m-%d", -- the date format passed to os.date
        text = {
            loading    = "   Loading",
            version    = "   %s",
            prerelease = "   %s",
            yanked     = "   %s",
            nomatch    = "   No match",
            upgrade    = "   %s",
            error      = "   Error fetching crate",
        },
        highlight = {
            loading    = "CratesNvimLoading",
            version    = "CratesNvimVersion",
            prerelease = "CratesNvimPreRelease",
            yanked     = "CratesNvimYanked",
            nomatch    = "CratesNvimNoMatch",
            upgrade    = "CratesNvimUpgrade",
            error      = "CratesNvimError",
        },
        popup = {
            autofocus = false, -- focus the versions popup when opening it
            copy_register = "\"", -- the register into which the version will be copied
            style = "minimal", -- same as nvim_open_win config.style
            border = "single", -- same as nvim_open_win config.border
            version_date = false, -- display when a version was released
            max_height = 30,
            min_width = 20,
            text = {
                title      = "  %s ",
                version    = "   %s ",
                prerelease = "  %s ",
                yanked     = "  %s ",
                feature    = "   %s ",
                date       = " %s ",
                enabled    = "  %s ",
                transitive = "  %s ",
            },
            highlight = {
                title      = "CratesNvimPopupTitle",
                version    = "CratesNvimPopupVersion",
                prerelease = "CratesNvimPopupPreRelease",
                yanked     = "CratesNvimPopupYanked",
                feature    = "CratesNvimPopupFeature",
                enabled    = "CratesNvimPopupEnabled",
                transitive = "CratesNvimPopupTransitive",
            },
            keys = {
                hide                 = { "q", "<ESC>" },
                select               = { "<CR>" },
                select_alt           = { "s" },
                copy_version         = { "yy" },
                toggle_feature       = { "<CR>" },
                goto_feature         = { "gd", "K" },
                jump_forward_feature = { "<C-i>" },
                jump_back_feature    = { "<C-o>" },
            },
        },
        cmp = {
            text = {
                prerelease = "  pre-release ",
                yanked     = "  yanked ",
            },
        },
    }

    require("crates").setup(opt)

    local wk = require("which-key")

    local mappings = {
        ["lc"] = {
            name = "Crates",
            t = { require("crates").toggle , "Toggle" },
            r = { require("crates").reload , "Reload" },
            v = { require("crates").show_versions_popup , "Versions popup" },
            f = { require("crates").show_features_popup , "Versions popup" },
            u = { require("crates").update_crate , "Update crate" },
            a = { require("crates").update_all_crates , "Update all crates" },
            U = { require("crates").upgrade_crate , "Upgrade crate" },
            A = { require("crates").upgrade_all_crates , "Upgrade all crates" },
        },
    }

    local visualMappings = {
        ["lc"] = {
            name = "Crates",
            u = { require("crates").update_crates , "Update crates" },
            U = { require("crates").upgrade_crates , "Upgrade crates" },
        }
    }

    wk.register(mappings, { prefix = "<leader>" })
    wk.register(visualMappings, { mode = "v", prefix = "<leader>" })

end

return M
