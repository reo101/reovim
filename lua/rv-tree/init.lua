local M = {}

M.config = function()

    local opt = {
        -- disables netrw completely
        disable_netrw       = true,
        -- hijack netrw window on startup
        hijack_netrw        = true,
        -- open the tree when running this setup function
        open_on_setup       = false,
        -- will not open on setup if the filetype is in this list
        ignore_ft_on_setup  = {},
        -- closes neovim automatically when the tree is the last **WINDOW** in the view
        auto_close          = true,
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab         = false,
        -- hijack the cursor in the tree to put it at the start of the filename
        hijack_cursor       = true,
        -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
        update_cwd          = true,
        -- show lsp diagnostics in the signcolumn
        diagnostics = {
            -- enables the feature
            enable = true,
            -- icons for diagnostic severity
            icons = {
                ["hint"] = "",
                ["info"] = "",
                ["warning"] = "",
                ["error"] = "",
            },
        },
        -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
        update_focused_file = {
            -- enables the feature
            enable      = true,
            -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
            -- only relevant when `update_focused_file.enable` is true
            update_cwd  = false,
            -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
            -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
            ignore_list = {},
        },
        -- configuration options for the system open command (`s` in the tree by default)
        system_open = {
            -- the command to run this, leaving nil should work in most cases
            cmd  = nil,
            -- the command arguments as a list
            args = {},
        },

        view = {
            -- width of the window, can be either a number (columns) or a string in `%`
            width = 30,
            -- side of the tree, can be one of "left" | "right" | "top" | "bottom"
            side = "right",
            -- if true the tree will resize itself after opening a file
            auto_resize = true,
            mappings = {
                -- custom only false will merge the list with the default mappings
                -- if true, it will only use your list to set the mappings
                custom_only = false,
                -- list of mappings to set on the tree manually
                list = {},
            },
        },
    }

    --  Dictionary of buffer option names mapped to a list of option values that
    --  indicates to the window picker that the buffer"s window should not be
    --  selectable.
    vim.g.nvim_tree_window_picker_exclude = {
        ["filetype"] = {
            "packer",
            "qf",
        },
        ["buftype"] = {
            "terminal",
        },
    }

    --  List of filenames that gets highlighted with NvimTreeSpecialFile
    vim.g.nvim_tree_special_files = {
        ["README.md"] = 1,
        ["Makefile"] = 1,
        ["MAKEFILE"] = 1,
    }

    -- 0 by default, this option shows indent markers when folders are open
    vim.g.nvim_tree_indent_markers = 1

    -- 0 by default, compact folders that only contain a single folder into one node in the file tree
    vim.g.nvim_tree_group_empty = 1

    -- If 0, do not show the icons for one of "git" "folder" and "files"
    -- 1 by default, notice that if "files" is 1, it will only display
    -- if nvim-web-devicons is installed and on your runtimepath.
    -- if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
    -- but this will not work when you set indent_markers (because of UI conflict)
    vim.g.nvim_tree_show_icons = {
        ["git"] = 1,
        ["folders"] = 1,
        ["files"] = 1,
        ["folder_arrows"] = 1,
    }

    --  default will show icon by default if no icon is provided
    --  default shows no icon by default
    vim.g.nvim_tree_icons = {
        ["default"] = "",
        ["symlink"] = "",
        ["git"] = {
            ["unstaged"] = "✗",
            ["staged"] = "✓",
            ["unmerged"] = "",
            ["renamed"] = "➜",
            ["untracked"] = "★",
            ["deleted"] = "",
            ["ignored"] = "◌",
        },
        ["folder"] = {
            ["arrow_open"] = "",
            ["arrow_closed"] = "",
            ["default"] = "",
            ["open"] = "",
            ["empty"] = "",
            ["empty_open"] = "",
            ["symlink"] = "",
            ["symlink_open"] = "",
        },
    }

    require("nvim-tree").setup(opt)

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            f = { require("nvim-tree").toggle, "FileTree" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    --nnoremap <C-n> :NvimTreeToggle<CR>
    --nnoremap <leader>r :NvimTreeRefresh<CR>
    --nnoremap <leader>n :NvimTreeFindFile<CR>
    --  NvimTreeOpen and NvimTreeClose are also available if you need them

    --  a list of groups can be found at `:help nvim_tree_highlight`
    --highlight NvimTreeFolderIcon guibg=blue

end

return M
