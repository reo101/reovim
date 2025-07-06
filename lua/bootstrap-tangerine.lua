--- HELPERS ---

local nvim_config = vim.fn.stdpath("config")
local nvim_data   = vim.fn.stdpath("data")
local pack_data   = nvim_data .. "/site/pack/core/opt"

--- BOOTSTRAP TANGERINE ---

vim.pack.add({{ src = "https://github.com/udayvir-singh/tangerine.nvim" }}, { confirm = false })

--- BOOTSTRAP TYPED-FENNEL ---

vim.pack.add({{ src = "https://github.com/reo101/typed-fennel", version = "subdirectories" }}, { confirm = false })

--- CONFIGURE TANGERINE ---

local seen_fnl_dirs = {}
local function attach_to_fennel(fennel)
  local rtp_dirs = vim.split(vim.o.runtimepath, ",")

  -- ["?.fnl" "?/init.fnl"]
  local default_patterns = vim.split(fennel["macro-path"], ";")

  local new_path_parts = {}

  -- Add all rtp dirs that have `fnl` subdirectories
  for _, rtp_dir in ipairs(rtp_dirs) do
    local fnl_dir = rtp_dir .. "/fnl"

    if vim.fn.isdirectory(fnl_dir) == 1 and not seen_fnl_dirs[fnl_dir] then
      for _, pattern in ipairs(default_patterns) do
        table.insert(new_path_parts, fnl_dir .. "/" .. pattern)
      end
      seen_fnl_dirs[fnl_dir] = true
    end
  end

  if #new_path_parts > 0 then
    local new_paths_str = table.concat(new_path_parts, ";")
    fennel["macro-path"] = new_paths_str .. ";" .. fennel["macro-path"]
  end
end

local opt = {
    vimrc   = nvim_config .. "/init.fnl",
    source  = nvim_config .. "/fnl",
    target  = nvim_data .. "/tangerine",
    rtpdirs = {
        "lsp",
        "plugin",
        "ftplugin",
        "ftdetect",
        "luasnippets",
        "after/plugin",
        "after/ftplugin",
        "after/ftdetect",
    },

    custom = {
        -- list of custom [source target] chunks, for example:
        -- {"~/.config/awesome/fnl", "~/.config/awesome/lua"}
        { pack_data .. "/typed-fennel/fnl", pack_data .. "/typed-fennel/lua" },
    },

    compiler = {
        float   = true,     -- show output in floating window
        clean   = true,     -- delete stale lua files
        force   = false,    -- disable diffing (not recommended)
        verbose = true,     -- enable messages showing compiled files

        globals = vim.tbl_keys(_G), -- list of alowedGlobals

        -- wrapper function that provides access to underlying fennel compiler
        -- useful if you want to modify fennel API or want to provide your own fennel compiler
        adviser = function (fennel)
            -- for example, adding a custom macro path:
            -- fennel["macro-path"] = fennel["macro-path"] .. ";/custom/path/?.fnl"
            -- return fennel

            local local_fennel_path = vim.env.HOME .. "/Projects/Home/Fennel/Fennel"

            if vim.fn.isdirectory(local_fennel_path) == 1 then
                -- Clean tangerine's fennel
                vim.iter(package.preload):filter(function (k, v)
                    return k:match("^fennel%.")
                end):each(function (k)
                    package.preload[k] = nil
                    package.loaded[k] = nil
                end)

                -- Bring in ours
                package.path = local_fennel_path .. "/?.lua;" .. package.path
                local local_fennel = require("fennel")
                -- TODO: why is this not needed
                for _, attr in ipairs({"path", "macro-path", "macroPath"}) do
                    local_fennel[attr] = fennel[attr]
                end

                fennel = local_fennel
            end

            return fennel
        end,

        -- version of fennel to use, [ latest, 1-4-0, 1-3-1, 1-3-0, 1-2-1, 1-2-0, 1-1-0, 1-0-0, 0-10-0, 0-9-2 ]
        -- version = "1-5-0-dev",
        version = "latest",

        -- hooks for tangerine to compile on:
        -- "onsave" run every time you save fennel file in {source} dir
        -- "onload" run on VimEnter event
        -- "oninit" run before sourcing init.fnl [recommended than onload]
        hooks = { "oninit", "onload", "onsave" },
    },

    eval = {
        float  = true,      -- show results in floating window

        -- luafmt = function() -- function that returns formatter with flags for peeked lua
        --     -- optionally install lua-format by `$ luarocks install --local --server=https://luarocks.org/dev luaformatter`
        --     return {"~/.luarocks/bin/lua-format", ...}
        -- end,

        diagnostic = {
            virtual = true,  -- show errors in virtual text
            timeout = 10,    -- how long should the error persist
        },
    },

    keymaps = {
        -- set them to <Nop> if you want to disable them
        eval_buffer = "gE",
        peek_buffer = "gL",
        goto_output = "gO",
        float = {
            next    = "<C-K>",
            prev    = "<C-J>",
            kill    = "<Esc>",
            close   = "<Enter>",
            resizef = "<C-W>=",
            resizeb = "<C-W>-",
        },
    },

    highlight = {
        float   = "Normal",
        success = "String",
        errors  = "DiagnosticError",
    },
}

require("tangerine").setup(opt)

--- BOOTSTRAP NIXCATS ---

vim.pack.add({{ src = "https://github.com/BirdeeHub/nixCats-nvim", version = "vim_pack" }}, { confirm = false }) -- "v6.0.8"

--- BOOTSTRAP LZE ---

-- TODO: fetch version from some lockfile, maybe in a nix-y way
vim.pack.add({{ src = "https://github.com/BirdeeHub/lze", version = "v0.12.0" }}, { confirm = false })
