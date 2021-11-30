local M  = {}

M.config = function()

    vim.g.aerial = {
        -- Priority list of preferred backends for aerial
        backends = { "lsp", "treesitter", "markdown" },

        -- Enum: persist, close, auto, global
        --   persist - aerial window will stay open until closed
        --   close   - aerial window will close when original file is no longer visible
        --   auto    - aerial window will stay open as long as there is a visible
        --             buffer to attach to
        --   global  - same as "persist", and will always show symbols for the current buffer
        close_behavior = "auto",

        -- Set to false to remove the default keybindings for the aerial buffer
        default_bindings = true,

        -- Enum: prefer_right, prefer_left, right, left
        -- Determines the default direction to open the aerial window. The "prefer"
        -- options will open the window in the other direction *if* there is a
        -- different buffer in the way of the preferred direction
        default_direction = "prefer_right",

        -- A list of all symbols to display. Set to false to display all symbols.
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Method",
            "Struct",
        },

        -- Enum: split_width, full_width, last, none
        -- Determines line highlighting mode when multiple buffers are visible
        highlight_mode = "split_width",

        -- When jumping to a symbol, highlight the line for this many ms
        -- Set to 0 or false to disable
        highlight_on_jump = 300,

        -- Fold code when folding the tree. Only works when manage_folds is enabled
        link_tree_to_folds = true,

        -- Fold the tree when folding code. Only works when manage_folds is enabled
        link_folds_to_tree = false,

        -- Use symbol tree for folding. Set to true or false to enable/disable
        -- "auto" will manage folds if your previous foldmethod was "manual"
        manage_folds = "auto",

        -- The maximum width of the aerial window
        max_width = 40,

        -- The minimum width of the aerial window.
        -- To disable dynamic resizing, set this to be equal to max_width
        min_width = 10,

        -- Set default symbol icons to use Nerd Font icons (see https://www.nerdfonts.com/)
        nerd_font = "auto",

        -- Whether to open aerial automatically when entering a buffer.
        -- Can also be specified per-filetype as a map (see below)
        open_automatic = false,

        -- If open_automatic is true, only open aerial if the source buffer is at
        -- least this long
        open_automatic_min_lines = 0,

        -- If open_automatic is true, only open aerial if there are at least this many symbols
        open_automatic_min_symbols = 0,

        -- Set to true to only open aerial at the far right/left of the editor
        -- Default behavior opens aerial relative to current window
        placement_editor_edge = false,

        -- Run this command after jumping to a symbol (false will disable)
        post_jump_cmd = "normal! zz",

        -- If close_on_select is true, aerial will automatically close after jumping to a symbol
        close_on_select = false,

        lsp = {
            -- Fetch document symbols when LSP diagnostics change.
            -- If you set this to false, you will need to manually fetch symbols
            diagnostics_trigger_update = true,

            -- Set to false to not update the symbols when there are LSP errors
            update_when_errors = true,
        },

        treesitter = {
            -- How long to wait (in ms) after a buffer change before updating
            update_delay = 300,
        },

        markdown = {
            -- How long to wait (in ms) after a buffer change before updating
            update_delay = 300,
        },
    }

-- open_automatic can be specified as a filetype map. For example, the below
-- configuration will open automatically in all filetypes except python and rust
    vim.g.aerial = {
        open_automatic = {
            -- use underscore to specify the default behavior
            ["_"]  = false,
            -- python = false,
            -- rust   = false,
        }
    }

-- backends can also be specified as a filetype map.
    vim.g.aerial = {
        backends = {
            -- use underscore to specify the default behavior
            ["_"]  = {"lsp", "treesitter"},
            -- python = {"treesitter"},
            -- rust   = {"lsp"},
        }
    }

-- filter_kind can also be specified as a filetype map.
    vim.g.aerial = {
        filter_kind = {
            -- use underscore to specify the default behavior
            -- ["_"]  = {"Class", "Function", "Interface", "Method", "Struct"},
            -- c = {"Namespace", "Function", "Struct", "Enum"}
        }
    }

-- You can also override the default icons.
    vim.g.aerial = {
        icons = {
            -- Class           = "",
            -- The icon to use when a class has been collapsed in the tree
            ClassCollapsed  = "喇",
            -- Function        = "",
            -- Constant        = "[c]",
            -- The default icon to use when any symbol is collapsed in the tree
            Collapsed       = "▶",

            File            = "",
            Module          = "",
            Namespace       = "",
            Package         = "",
            Class           = "𝓒",
            Method          = "ƒ",
            Property        = "",
            Field           = "",
            Constructor     = "",
            Enum            = "ℰ",
            Interface       = "ﰮ",
            Function        = "",
            Variable        = "",
            Constant        = "",
            String          = "𝓐",
            Number          = "#",
            Boolean         = "⊨",
            Array           = "",
            Object          = "⦿",
            Key             = "🔐",
            Null            = "NU",
            EnumMember      = "",
            Struct          = "𝓢",
            Event           = "🗲",
            Operator        = "+",
            TypeParameter   = "𝙏",
        }
    }

    local wk = require("which-key")

    local mappings = {
        t = {
            name = "Toggle",
            a = { require("aerial").toggle, "Aerial" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

end

return M
