local M = {}

M.config = function ()

    local da = require("diffview.actions")

    local opt = {
        diff_binaries = false,    -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ":h diffview-config-enhanced_diff_hl"
        use_icons = true,         -- Requires nvim-web-devicons
        icons = {                 -- Only applies when use_icons is true.
            folder_closed = "",
            folder_open = "",
        },
        signs = {
            fold_closed = "",
            fold_open = "",
        },
        file_panel = {
            win_config = {
                position = "left",        -- One of "left", "right", "top", "bottom"
                width = 35,               -- Only applies when position is "left" or "right"
                height = 10,              -- Only applies when position is "top" or "bottom"
            },
            listing_style = "tree",       -- One of "list" or "tree"
            tree_options = {              -- Only applies when listing_style is "tree"
                flatten_dirs = true,
                folder_statuses = "always"  -- One of "never", "only_folded" or "always".
            }
        },
        file_history_panel = {
            win_config = {
                position = "bottom",
                width = 35,
                height = 16,
            },
            log_options = {
                git = {
                    single_file = {
                        max_count = 512,      -- Limit the number of commits
                        follow = false,       -- Follow renames (only for single file)
                    },
                    multi_file = {
                        max_count = 128,
                        -- follow = false   -- `follow` only applies to single-file history
                    },
                    all = false,          -- Include all refs under "refs/" including HEAD
                    merges = false,       -- List only merge commits
                    no_merges = false,    -- List no merge commits
                    reverse = false,      -- List commits in reverse order

                },
            },
        },
        key_bindings = {
            disable_defaults = false,                   -- Disable the default key bindings
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            view = {
                ["<tab>"]      = da.select_next_entry,  -- Open the diff for the next file
                ["<s-tab>"]    = da.select_prev_entry,  -- Open the diff for the previous file
                ["gf"]         = da.goto_file,          -- Open the file in a new split in previous tabpage
                ["<C-w><C-f>"] = da.goto_file_split,    -- Open the file in a new split
                ["<C-w>gf"]    = da.goto_file_tab,      -- Open the file in a new tabpage
                ["<leader>e"]  = da.focus_files,        -- Bring focus to the files panel
                ["<leader>b"]  = da.toggle_files,       -- Toggle the files panel.
            },
            file_panel = {
                ["j"]             = da.next_entry,           -- Bring the cursor to the next file entry
                ["<down>"]        = da.next_entry,
                ["k"]             = da.prev_entry,           -- Bring the cursor to the previous file entry.
                ["<up>"]          = da.prev_entry,
                ["<cr>"]          = da.select_entry,         -- Open the diff for the selected entry.
                ["o"]             = da.select_entry,
                ["<2-LeftMouse>"] = da.select_entry,
                ["-"]             = da.toggle_stage_entry,   -- Stage / unstage the selected entry.
                ["S"]             = da.stage_all,            -- Stage all entries.
                ["U"]             = da.unstage_all,          -- Unstage all entries.
                ["X"]             = da.restore_entry,        -- Restore entry to the state on the left side.
                ["R"]             = da.refresh_files,        -- Update stats and entries in the file list.
                ["L"]             = da.open_commit_log,
                ["<c-b>"]         = da.scroll_view(-0.25),
                ["<c-f>"]         = da.scroll_view(0.25),
                ["<tab>"]         = da.select_next_entry,
                ["<s-tab>"]       = da.select_prev_entry,
                ["gf"]            = da.goto_file,
                ["<C-w><C-f>"]    = da.goto_file_split,
                ["<C-w>gf"]       = da.goto_file_tab,
                ["i"]             = da.listing_style,        -- Toggle between "list" and "tree" views
                ["f"]             = da.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
                ["<leader>e"]     = da.focus_files,
                ["<leader>b"]     = da.toggle_files,
                ["g<C-x>"]        = da.cycle_layout,
                ["[x"]            = da.prev_conflict,
                ["]x"]            = da.next_conflict,
            },
            file_history_panel = {
                ["g!"]            = da.options,            -- Open the option panel
                ["<C-d>"]         = da.open_in_diffview,   -- Open the entry under the cursor in a diffview
                ["y"]             = da.copy_hash,
                ["L"]             = da.open_commit_log,
                ["zR"]            = da.open_all_folds,
                ["zM"]            = da.close_all_folds,
                ["j"]             = da.next_entry,
                ["<down>"]        = da.next_entry,
                ["k"]             = da.prev_entry,
                ["<up>"]          = da.prev_entry,
                ["<cr>"]          = da.select_entry,
                ["o"]             = da.select_entry,
                ["<2-LeftMouse>"] = da.select_entry,
                ["<c-b>"]         = da.scroll_view(-0.25),
                ["<c-f>"]         = da.scroll_view(0.25),
                ["<tab>"]         = da.select_next_entry,
                ["<s-tab>"]       = da.select_prev_entry,
                ["gf"]            = da.goto_file,
                ["<C-w><C-f>"]    = da.goto_file_split,
                ["<C-w>gf"]       = da.goto_file_tab,
                ["<leader>e"]     = da.focus_files,
                ["<leader>b"]     = da.toggle_files,
                ["g<C-x>"]        = da.cycle_layout,
            },
            option_panel = {
                ["<tab>"] = da.select_entry,
                ["q"]     = da.close,
            },
        },
    }

    require("diffview").setup(opt)

end

return M
