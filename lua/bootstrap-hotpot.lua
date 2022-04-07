-- Bootstrap hotpot
local install_path = string.format(
    "%s/site/pack/packer/start/hotpot.nvim",
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
    vim.cmd("packadd hotpot.nvim")
    vim.cmd("helptags " .. install_path .. "/doc")
end

-- Start up hotpot
require("hotpot").setup({
    provide_require_fennel = true,
    compiler = {
        modules = {
            correlate = false,
        },
        macros = {
            env = "_COMPILER",
        },
    },
})
