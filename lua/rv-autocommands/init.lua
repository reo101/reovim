vim.cmd [[
    autocmd FileType lspinfo nnoremap <silent> <buffer> q :q<CR>
]]

local function set_shiftwidth(filetype, shiftwidth)
    vim.cmd(string.format(
        [[ autocmd Filetype %s setlocal expandtab tabstop=%d shiftwidth=%d softtabstop=%d ]],
        filetype, shiftwidth, shiftwidth, shiftwidth
    ))
end

set_shiftwidth("haskell", 2)
set_shiftwidth("norg", 2)
