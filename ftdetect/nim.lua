vim.api.nvim_create_augroup("nim_vim", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = {
        "*.nim",
        "*.nims",
        "*.nimble",
    },
    group = "nim_vim",
    -- callback = function()
    --     vim.cmd([[set filetype=nim]])
    -- end,
    command = [[set filetype=nim]],
})
