local M = {}

M.config = function()

    local opt = {
        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities =require("rv-lsp.utils").capabilities,
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        filetypes = { "haskell", "lhaskell" },
        lspinfo = function()
            local extra = {}

            local function on_stdout(_, data, _)
                local version = data[1]
                table.insert(extra, 'version:   ' .. version)
            end

            local opts = {
                cwd = require("lspconfig.config").cwd,
                stdout_buffered = true,
                on_stdout = on_stdout,
            }

            local chanid = vim.fn.jobstart({ require("lspconfig.config").cmd[1], '--version' }, opts)

            vim.fn.jobwait { chanid }

            return extra
        end,
        root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = {
                "*.cabal",
                "stack.yaml",
                "cabal.project",
                "package.yaml",
                "hie.yaml",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
        settings = {
            haskell = {
                formattingProvider = "ormolu"
            },
        },
    }

    require("lspconfig")["hls"].setup(opt)

end

return M
