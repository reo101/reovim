vim.api.nvim_create_augroup("crisp_vim", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = {
        "*.crisp",
    },
    group = "crisp_vim",
    -- callback = function()
    --     vim.cmd([[set filetype=nim]])
    -- end,
    command = [[set filetype=crisp]],
})
