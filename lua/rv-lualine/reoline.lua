local config = {}

local gps = require("nvim-gps")
-- local palette = require("nightfox.palette").load("nightfox")
-- local Color = require("nightfox.lib.color")

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

local function keymap()
    if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
        return "⌨ " .. vim.b.keymap_name
    end
    return ""
end

local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local default_status_colors = { saved = "#228B22", modified = "#C70039" }

function custom_fname:init(options)
    custom_fname.super.init(self, options)

    self.status_colors = {
        saved = highlight.create_component_highlight_group(
            { bg = default_status_colors.saved },
            "filename_status_saved",
            self.options
        ),
        modified = highlight.create_component_highlight_group(
            { bg = default_status_colors.modified },
            "filename_status_modified",
            self.options
        ),
    }

    self.options.color = self.options.color or ""
end

function custom_fname:update_status()
    local data = custom_fname.super.update_status(self)

    data = highlight.component_format_highlight(
        vim.bo.modified and self.status_colors.modified
            or self.status_colors.saved
    ) .. data

    return data
end

config.options = {
    icons_enabled = true,
    theme = "tokyonight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
}

config.sections = {
    lualine_a = {
        "mode",
    },
    lualine_b = {
        {
            keymap,
        },
        -- custom_fname,
        "filename",
    },
    lualine_c = {
        {
            gps.get_location,
            cond = gps.is_available,
        },
    },
    lualine_x = {
        "filetype",
        "encoding",
        "fileformat",
    },
    lualine_y = {
        "diagnostics",
        {
            "diff",
            source = diff_source,
        },
        {
            "b:gitsigns_head",
            icon = "",
        },
    },
    lualine_z = {
        "progress",
        "location",
    },
}

config.inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
}

config.tabline = {}

config.extensions = {
    "aerial",
    "toggleterm",
    "quickfix",
}

-- local bg = Color.from_hex(pallet.bg1)
-- local red = Color.from_hex("#ff0000")
--
-- -- Blend the bg with red. The blend factor is from 0 to 1
-- -- with 0 being full bg and 1 being full red
-- local red_bg = bg:blend(red, 0.2)
--
-- print(red_bg:to_css())
-- -- "#471c26"
--
-- -- Brighten bg by adding 10 to the value of the color as a hsv
-- local alt_bg = bg:brighten(10)
-- print(vim.inspect(alt_bg:to_hsv()))
-- -- {
-- --   hue = 213.91304347826,
-- --   saturation = 47.916666666667,
-- --   value = 28.823529411765
-- -- }

-- config.sections = {
--     lualine_c = {
--         {
--             gps.get_location,
--             cond = gps.is_available,
--         },
--     },
-- }
--
-- config.normal = {
--     a = {
--         bg = colors.blue,
--         fg = colors.black,
--     },
--     b = {
--         bg = colors.fg_gutter,
--         fg = colors.blue,
--     },
--     c = {
--         bg = colors.bg_statusline,
--         fg = colors.fg_sidebar,
--     },
-- }
--
-- config.insert = {
--     a = {
--         bg = colors.green,
--         fg = colors.black,
--     },
--     b = {
--         bg = colors.fg_gutter,
--         fg = colors.green,
--     },
-- }
--
-- config.command = {
--     a = {
--         bg = colors.yellow,
--         fg = colors.black,
--     },
--     b = {
--         bg = colors.fg_gutter,
--         fg = colors.yellow,
--     },
-- }
--
-- config.visual = {
--     a = {
--         bg = colors.magenta,
--         fg = colors.black,
--     },
--     b = {
--         bg = colors.fg_gutter,
--         fg = colors.magenta,
--     },
-- }
--
-- config.replace = {
--     a = {
--         bg = colors.red,
--         fg = colors.black,
--     },
--     b = {
--         bg = colors.fg_gutter,
--         fg = colors.red,
--     },
-- }
--
-- config.inactive = {
--     a = {
--         bg = colors.bg_statusline,
--         fg = colors.blue,
--     },
--     b = {
--         bg = colors.bg_statusline,
--         fg = colors.fg_gutter,
--         gui = "bold",
--     },
--     c = {
--         bg = colors.bg_statusline,
--         fg = colors.fg_gutter,
--     },
-- }

-- if vim.o.background == "light" then
--     for _, mode in pairs(config) do
--         for _, section in pairs(mode) do
--             if section.bg then
--                 section.bg = util.getColor(section.bg)
--             end
--             if section.fg then
--                 section.fg = util.getColor(section.fg)
--             end
--         end
--     end
-- end

if vim.g.config_lualine_bold then
    for _, mode in pairs(config) do
        mode.a.gui = "bold"
    end
end

return config
