-- Bootstrap hotpot
local install_path = string.format(
    "%s/lazy/hotpot.nvim",
    vim.fn.stdpath("data")
)

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print(
        string.format(
            "Could not find hotpot.nvim, cloning new copy to %s",
            install_path
        )
    )
    vim.fn.system({
        "git",
        "clone",
        "https://www.github.com/rktjmp/hotpot.nvim",
        install_path,
    })
    -- vim.cmd("packadd hotpot.nvim")
    vim.opt.rtp:prepend(install_path)
    vim.cmd("helptags " .. install_path .. "/doc")
end

-- Start up hotpot
require("hotpot").setup({
    provide_require_fennel = true,
    enable_hotpot_diagnostics = false,
    compiler = {
        modules = {
            correlate = false,
        },
        macros = {
          env = "_COMPILER",
          compilerEnv = _G,
          allowGlobals = false,
        }
    },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
