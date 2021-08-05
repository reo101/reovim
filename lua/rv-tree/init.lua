local M = {}

M.config = function()

    -- left by default
    vim.g.nvim_tree_side = "left"

    -- 30 by default, can be width_in_columns or "width_in_percent%"
    vim.g.nvim_tree_width = 20

    -- empty by default
    vim.g.nvim_tree_ignore = {
        ".git",
        "node_modules",
        ".cache"
    }

    -- 0 by default
    vim.g.nvim_tree_gitignore = 1

    -- 0 by default, opens the tree when typing `vim $DIR` or `vim`
    vim.g.nvim_tree_auto_open = 0

    -- 0 by default, closes the tree when it's the last window
    vim.g.nvim_tree_auto_close = 1

    -- empty by default, don"t auto open tree on specific filetypes.
    vim.g.nvim_tree_auto_ignore_ft = {
        "startify",
        "dashboard"
    }

    -- 0 by default, closes the tree when you open a file
    vim.g.nvim_tree_quit_on_open = 1 -- TODO

    -- 0 by default, this option allows the cursor to be updated when entering a buffer
    vim.g.nvim_tree_follow = 1

    -- 0 by default, this option shows indent markers when folders are open
    vim.g.nvim_tree_indent_markers = 1

    -- 0 by default, this option hides files and folders starting with a dot `.`
    vim.g.nvim_tree_hide_dotfiles = 1

    -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
    vim.g.nvim_tree_git_hl = 1

    -- 0 by default, will enable folder and file icon highlight for opened files/directories.
    vim.g.nvim_tree_highlight_opened_files = 1

    -- This is the default. See :help filename-modifiers for more options
    vim.g.nvim_tree_root_folder_modifier = ":~"

    -- 0 by default, will open the tree when entering a new tab and the tree was previously open
    vim.g.nvim_tree_tab_open = 1

    -- 1 by default, will resize the tree to its saved width when opening a file
    vim.g.nvim_tree_auto_resize = 1

    -- 1 by default, disables netrw
    vim.g.nvim_tree_disable_netrw = 1

    -- 1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
    vim.g.nvim_tree_hijack_netrw = 1

    -- 0 by default, append a trailing slash to folder names
    vim.g.nvim_tree_add_trailing = 1

    --  0 by default, compact folders that only contain a single folder into one node in the file tree
    vim.g.nvim_tree_group_empty = 1

    -- 0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
    vim.g.nvim_tree_lsp_diagnostics = 1

    -- 0 by default, will disable the window picker.
    vim.g.nvim_tree_disable_window_picker = 0

    -- 1 by default, when moving cursor in the tree, will position the cursor at the start of the file on the current line
    vim.g.nvim_tree_hijack_cursor = 1

    -- one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
    vim.g.nvim_tree_icon_padding = " "

    --  defaults to " ➛ ". used as a separator between symlinks" source and target.
    vim.g.nvim_tree_symlink_arrow = " >> "

    -- 0 by default, will update the tree cwd when changing nvim"s directory (DirChanged event). Behaves strangely with autochdir set.
    vim.g.nvim_tree_update_cwd = 1

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

    -- If 0, do not show the icons for one of "git" "folder" and "files"
    -- 1 by default, notice that if "files" is 1, it will only display
    -- if nvim-web-devicons is installed and on your runtimepath.
    -- if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
    -- but this will not work when you set indent_markers (because of UI conflict)
    vim.g.nvim_tree_show_icons = {
        ["git"] = 1,
        ["folders"] = 0,
        ["files"] = 0,
        ["folder_arrows"] = 0,
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
        ["lsp"] = {
            ["hint"] = "",
            ["info"] = "",
            ["warning"] = "",
            ["error"] = "",
        },
    }

    local tree = {}
    function tree.toggle()
        local view = require("nvim-tree.view")
        local lib = require("nvim-tree.lib")

        if view.win_open() then
            require("bufferline.state").set_offset(0)
            view.close()
        else
            if vim.g.nvim_tree_follow == 1 then
                require("bufferline.state").set_offset(vim.g.nvim_tree_width, "FileTree")
                require("nvim-tree").find_file(true)
            end
            if not view.win_open() then
                lib.open()
            end
        end
    end

    -- TODO % in tree and barbar offset

    -- TEST
    -- require("nvim-tree").toggle = tree.toggle

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            t = { tree.toggle, "Tree" },
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
