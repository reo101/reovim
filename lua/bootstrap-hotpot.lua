-- Bootstrap lazy
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazy_path,
  })
end

-- Bootstrap hotpot
local hotpot_path = vim.fn.stdpath("data") .. "/lazy/hotpot.nvim"

if vim.fn.empty(vim.fn.glob(hotpot_path)) > 0 then
    print(
        string.format(
            "Could not find hotpot.nvim, cloning new copy to %s",
            hotpot_path
        )
    )
    vim.fn.system({
        "git",
        "clone",
        "https://www.github.com/rktjmp/hotpot.nvim",
        hotpot_path,
    })
end

vim.opt.rtp:prepend(lazy_path)
vim.opt.rtp:prepend(hotpot_path)
vim.cmd("helptags " .. hotpot_path .. "/doc")

-- Start up hotpot
require("hotpot").setup({
    provide_require_fennel = true,
    enable_hotpot_diagnostics = false,
    compiler = {
        modules = {
            correlate = true,
        },
        macros = {
          env = "_COMPILER",
          compilerEnv = _G,
          allowGlobals = false,
        }
    },
})
