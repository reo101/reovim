--- GLOBALS ---

HOME_PATH   = vim.fn.expand("$HOME")
CONFIG_PATH = vim.fn.stdpath("config")
DATA_PATH   = vim.fn.stdpath("data")
CACHE_PATH  = vim.fn.stdpath("cache")
TERMINAL    = vim.fn.expand("$TERMINAL")

---  VIM ONLY COMMANDS  ---

vim.cmd(string.format([[let &titleold="%s"]], TERMINAL))
vim.cmd("set inccommand=split")
vim.cmd("set iskeyword+=-")
vim.cmd("set iskeyword-=:")
vim.cmd("set whichwrap+=<,>,[,],h,l")
-- vim.cmd("au ColorScheme * hi Normal ctermbg=none guibg=none")
-- vim.cmd("au ColorScheme * hi SignColumn ctermbg=none guibg=none")

---  SETTINGS  ---

vim.g.mapleader        = " "                            -- maps the leader to space
vim.g.maplocalleader   = " "                            -- maps the local leader to space
vim.opt.backup         = false                          -- creates a backup file
-- vim.opt.breakindent    = true                           -- indent wrapped lines
-- vim.opt.breakindentopt = { "shift:2", "min:40", "sbr"}  -- options for breakindent
-- vim.opt.showbreak      = ">>"                           -- string to show when wrapping a line
vim.opt.clipboard      = "unnamedplus"                  -- allows neovim to access the system clipboard
vim.opt.cmdheight      = 1                              -- more space in the neovim command line for displaying messages
-- vim.opt.colorcolumn    = "80"                           -- visual reminder for 80 char line limit
vim.opt.completeopt    = { "menuone", "noselect" }
vim.opt.concealcursor  = "nc"                           -- only conceal when in normal or command mode
vim.opt.conceallevel   = 2                              -- completely hidden conceals
-- vim.opt.cursorcolumn   = true                           -- highlight the current column
vim.opt.cursorline     = true                           -- highlight the current line
vim.opt.cursorlineopt  = "number"                       -- highlight currect line number
vim.opt.expandtab      = true                           -- convert tabs to spaces
vim.opt.fileencoding   = "utf-8"                        -- the encoding written to a file
vim.opt.guifont        = "Fira Code Mono Nerd Font:h17" -- the font used in graphical neovim applications
vim.opt.hidden         = true                           -- required to keep multiple buffers and open multiple buffers
vim.opt.hlsearch       = true                           -- highlight all matches on previous search pattern
vim.opt.ignorecase     = true                           -- ignore case in search patterns
vim.opt.laststatus     = 3                              -- global statusline
vim.opt.mouse          = "a"                            -- allow the mouse to be used in neovim
vim.opt.number         = true                           -- set numbered lines
vim.opt.pumblend       = 20                             -- winblend for the autocompletion window
vim.opt.pumheight      = 10                             -- pop up menu height
vim.opt.relativenumber = true                           -- set relatively numbered lines
vim.opt.scrolloff      = 3                              -- always keep the cursor 3 lines away from the edge
vim.opt.shiftwidth     = 4                              -- the number of spaces inserted for each indentation
vim.opt.shortmess:append("c")                           -- Hide "Pattern not found" when no completion is available
vim.opt.shortmess:remove("F")                           -- Ensure autocmd works for Filetype
vim.opt.showmode       = false                          -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline    = 2                              -- always show tabline
vim.opt.signcolumn     = "auto:3"                       -- always show the sign column, otherwise it would shift the text each time
vim.opt.smartcase      = true                           -- smart case
vim.opt.smartindent    = true                           -- make indenting smarter again
vim.opt.softtabstop    = 4                              -- more tab is 4 spaces config
vim.opt.splitbelow     = true                           -- force all horizontal splits to go below current window
vim.opt.splitright     = true                           -- force all vertical splits to go to the right of current window
vim.opt.swapfile       = false                          -- creates a swapfile
vim.opt.tabstop        = 4                              -- insert 4 spaces for a tab
vim.opt.termguicolors  = true                           -- set term gui colors (most terminals support this)
vim.opt.timeoutlen     = 300                            -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title          = true                           -- set the title of window to the value of the titlestring
vim.opt.titlestring    = "%<%F%=%l/%L - nvim"           -- what the title of the window will be set to
vim.opt.undodir        = CACHE_PATH .. "/undo"          -- set an undo directory
vim.opt.undofile       = true                           -- enable persistent undo
vim.opt.updatetime     = 300                            -- faster completion
vim.opt.winblend       = 20                             -- winblend for floating windows
vim.opt.wrap           = true                           -- display lines as one long line
vim.opt.writebackup    = false                          -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
-- vim.wo.fillchars = "fold: "
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.wo.foldmethod = "expr"
-- vim.wo.foldminlines = 1
-- vim.wo.foldnestmax = 3
-- vim.wo.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]

-- disable builtin plugins
local disabled_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "matchparen",
    "spec",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin"
}

for _, plugin in ipairs(disabled_plugins) do
    vim.g["loaded_" .. plugin] = 1
end
