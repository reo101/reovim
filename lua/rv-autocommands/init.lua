local function add_autocmd(event, pattern, command)
    vim.cmd(string.format(
        [[ autocmd %s %s %s ]],
        event, pattern, command
    ))
end

add_autocmd("FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>")

local autocmds = {
    packer = {
        -- { "BufWritePost", "plugins.lua", "PackerCompile" },
    },
    terminal_job = {
        { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
        -- { "TermOpen", "*", [[tnoremap <buffer> <leader>x <c-\><c-n>:bd!<cr>]] },
        -- { "TermOpen", "*", [[tnoremap <expr> <A-r> '<c-\><c-n>"'.nr2char(getchar()).'pi' ]]},
        { "TermOpen", "*", "startinsert" },
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
    },
    restore_cursor = {
        { 'BufRead', '*', [[call setpos(".", getpos("'\""))]] },
    },
    save_shada = {
        {"VimLeave", "*", "wshada!"},
    },
    toggle_search_highlighting = {
        { "InsertEnter", "*", "setlocal nohlsearch" },
    },
    lua_highlight = {
        { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank({ higroup="IncSearch", timeout=300 })]] },
    },
    lsp_info = {
        { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
    },
}

for _, group in pairs(autocmds) do
    for _, autocmd in pairs(group) do
        add_autocmd(autocmd[1], autocmd[2], autocmd[3])
    end
end

local function set_shiftwidth(filetype, shiftwidth)
    add_autocmd("FileType", filetype, string.format(
        [[ setlocal expandtab tabstop=%d shiftwidth=%d softtabstop=%d ]],
        shiftwidth, shiftwidth, shiftwidth
    ))
end

set_shiftwidth("haskell", 2)
set_shiftwidth("norg", 2)
set_shiftwidth("xml", 2)
