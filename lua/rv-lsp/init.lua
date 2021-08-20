--------- LSPCONFIG ---------

local nvim_lsp = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Mappings.
    local wk = require("which-key")

    local mappings = {
        l = {
            name = "LSP",
            g = {
                name = "Go",
                d = { vim.lsp.buf.definition, "Definition" },
                D = { vim.lsp.buf.declaration, "Decaration" },
                y = { vim.lsp.buf.type_definition, "Type Definition" },
                r = { vim.lsp.buf.references, "References" },
                i = { vim.lsp.buf.implementation, "Implementation" },
            },
            d = {
                name = "Diagnostics",
                n = { vim.lsp.diagnostic.goto_prev, "Next" },
                p = { vim.lsp.diagnostic.goto_next, "Previous" },
                l = { vim.lsp.diagnostic.show_line_diagnostics, "Line Diagnostics" },
                q = { vim.lsp.diagnostic.set_loclist, "Send to loclist"},
            },
            r = { vim.lsp.buf.rename, "Rename" },
            a = { vim.lsp.buf.code_action, "Code Action" },
            f = { vim.lsp.buf.formatting, "Format" },
            w = {
                name = "Workspace",
                a = { vim.lsp.buf.add_workspace_folder , "Add" },
                r = { vim.lsp.buf.remove_workspace_folder , "Remove" },
                l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end , "List" },
            },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })

    local directMappings = {
        g = {
            d = { function() vim.lsp.buf.definition() end, "Definition" },
            D = { function() vim.lsp.buf.declaration() end, "Decaration" },
            y = { function() vim.lsp.buf.type_definition() end, "Type Definition" },
            r = { function() vim.lsp.buf.references() end, "References" },
            i = { function() vim.lsp.buf.implementation() end, "Implementation" },
        },
        K = { function() vim.lsp.buf.hover() end, "Hover" },
    }

    wk.register(directMappings, { mode = "n", prefix = "" })

    local motionMappings = {
        ["[d"] = { function() vim.lsp.diagnostic.goto_prev() end, "Previous Diagnostic" },
        ["]d"] = { function() vim.lsp.diagnostic.goto_prev() end, "Next Diagnostic" },
    }

    wk.register(motionMappings, { mode = "n", prefix = "" })
    wk.register(motionMappings, { mode = "o", prefix = "" })

    require("rv-lsp/signature").config()
end

--------- LSPINSTALL ---------

local function setup_servers()
    require("lspinstall").setup()
    local servers = require("lspinstall").installed_servers()
    local localConfigs = { "cpp", "latex" }
    local opt
    for _, server in pairs(servers) do
        if vim.tbl_contains(localConfigs, server) then
            require("rv-lsp/" .. server).setup(on_attach)
        else
            opt = {
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 150,
                },
            }
            require("lspconfig")[server].setup(opt)
        end
    end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require("lspinstall").post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
--[[ local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        },
    }
end ]]
