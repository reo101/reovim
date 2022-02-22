local M = {}

M.config = function()

    -- |Alias Name                                |Explanation                                      |Examples                           |
    -- |------------------------------------------|-------------------------------------------------|-----------------------------------|
    -- |`augend.integer.alias.decimal`            |decimal natural number                           |`0`, `1`, ..., `9`, `10`, `11`, ...|
    -- |`augend.integer.alias.decimal_int`        |decimal integer (including negative number)      |`0`, `314`, `-1592`, ...           |
    -- |`augend.integer.alias.hex`                |hex natural number                               |`0x00`, `0x3f3f`, ...              |
    -- |`augend.integer.alias.octal`              |octal natural number                             |`0o00`, `0o11`, `0o24`, ...        |
    -- |`augend.integer.alias.binary`             |binary natural number                            |`0b0101`, `0b11001111`, ...        |
    -- |`augend.date.alias["%Y/%m/%d"]`           |Date in the format `%Y/%m/%d` (`0` padding)      |`2021/01/23`, ...                  |
    -- |`augend.date.alias["%m/%d/%Y"]`           |Date in the format `%m/%d/%Y` (`0` padding)      |`23/01/2021`, ...                  |
    -- |`augend.date.alias["%d/%m/%Y"]`           |Date in the format `%d/%m/%Y` (`0` padding)      |`01/23/2021`, ...                  |
    -- |`augend.date.alias["%m/%d/%y"]`           |Date in the format `%m/%d/%y` (`0` padding)      |`01/23/21`, ...                    |
    -- |`augend.date.alias["%d/%m/%y"]`           |Date in the format `%d/%m/%y` (`0` padding)      |`23/01/21`, ...                    |
    -- |`augend.date.alias["%m/%d"]`              |Date in the format `%m/%d` (`0` padding)         |`01/04`, `02/28`, `12/25`, ...     |
    -- |`augend.date.alias["%-m/%-d"]`            |Date in the format `%-m/%-d` (no paddings)       |`1/4`, `2/28`, `12/25`, ...        |
    -- |`augend.date.alias["%Y-%m-%d"]`           |Date in the format `%Y-%m-%d` (`0` padding)      |`2021-01-04`, ...                  |
    -- |`augend.date.alias["%Y年%-m月%-d日"]`       |Date in the format `%Y年%-m月%-d日` (no paddings)|`2021年1月4日`, ...                |
    -- |`augend.date.alias["%Y年%-m月%-d日(%ja)"]`  |Date in the format `%Y年%-m月%-d日(%ja)`         |`2021年1月4日(月)`, ...            |
    -- |`augend.date.alias["%H:%M:%S"]`           |Time in the format `%H:%M:%S`                    |`14:30:00`, ...                    |
    -- |`augend.date.alias["%H:%M"]`              |Time in the format `%H:%M`                       |`14:30`, ...                       |
    -- |`augend.constant.alias.ja_weekday`        |Japanese weekday                                 |`月`, `火`, ..., `土`, `日`        |
    -- |`augend.constant.alias.ja_weekday_full`   |Japanese full weekday                            |`月曜日`, `火曜日`, ..., `日曜日`  |
    -- |`augend.constant.alias.bool`              |elements in boolean algebra (`true` and `false`) |`true`, `false`                    |
    -- |`augend.constant.alias.alpha`             |Lowercase alphabet letter (word)                 |`a`, `b`, `c`, ..., `z`            |
    -- |`augend.constant.alias.Alpha`             |Uppercase alphabet letter (word)                 |`A`, `B`, `C`, ..., `Z`            |
    -- |`augend.semver.alias.semver`              |Semantic version                                 |`0.3.0`, `1.22.1`, `3.9.1`, ...    |

    local augend = require("dial.augend")

    local default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.date.alias["%Y/%m/%d"],
        augend.semver.alias.semver,
        augend.constant.alias.bool,
    }

    local haskellBoolean = augend.constant.new {
        desc = "Haskell True/False",
        elements = {
            "True",
            "False",
        },
        word = true,
        cyclic = true,
    }

    local zigOctal = augend.user.new({
        desc = "Zig/Rust octal integers",
        find = require("dial.augend.common").find_pattern("0o[0-7]+"),
        add = function(text, addend, cursor)
            local wid = #text
            local n = tonumber(string.sub(text, 3), 8)
            n = n + addend
            if n < 0 then
                n = 0
            end
            text = "0o" .. require("dial.util").tostring_with_base(n, 8, wid - 2, "0")
            cursor = #text
            return {
                text = text,
                cursor = cursor,
            }
        end,
    })

    local rustOctal = zigOctal

    local augends_group = {
        default = default,
        haskell = vim.tbl_extend("keep", {
            augend.integer.alias.decimal,
            haskellBoolean,
        }, {}),
        -- zig = vim.tbl_extend("keep", {
        --     zigOctal,
        -- }, default),
        zig = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.integer.alias.binary,
            augend.date.alias["%Y/%m/%d"],
            augend.semver.alias.semver,
            augend.constant.alias.bool,

            zigOctal,
        },
        -- rust = vim.tbl_extend("keep", {
        --     rustOctal,
        -- }, default),
        rust = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.integer.alias.binary,
            augend.date.alias["%Y/%m/%d"],
            augend.semver.alias.semver,
            augend.constant.alias.bool,

            rustOctal,
        },
    }

    require("dial.config").augends:register_group(augends_group)

    local wk = require("which-key")

    local normalMappings = {
        ["<C-a>"] = { require("dial.map").inc_normal(), "Increment" },
        ["<C-x>"] = { require("dial.map").dec_normal(), "Decrement" },
    }
    local visualMappings = {
        ["<C-a>"] = { require("dial.map").inc_visual(), "Increment" },
        ["<C-x>"] = { require("dial.map").dec_visual(), "Decrement" },
        ["g<C-a>"] = { require("dial.map").inc_gvisual(), "Increment" },
        ["g<C-x>"] = { require("dial.map").dec_gvisual(), "Decrement" },
    }

    wk.register(normalMappings, { mode = "n", prefix = "" })
    wk.register(visualMappings, { mode = "v", prefix = "" })

    vim.cmd([[
        augroup Dial
            autocmd!
            autocmd FileType haskell lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("haskell"), {noremap = true})
            autocmd FileType zig lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("zig"), {noremap = true})
            autocmd FileType rust lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("rust"), {noremap = true})
        augroup END
    ]])

end

return M
