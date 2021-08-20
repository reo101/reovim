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
                d = { function() vim.lsp.buf.definition() end, "Definition" },
                D = { function() vim.lsp.buf.declaration() end, "Decaration" },
                y = { function() vim.lsp.buf.type_definition() end, "Type Definition" },
                r = { function() vim.lsp.buf.references() end, "References" },
                i = { function() vim.lsp.buf.implementation() end, "Implementation" },
            },
            d = {
                name = "Diagnostics",
                n = { function() vim.lsp.diagnostic.goto_prev() end, "Next" },
                p = { function() vim.lsp.diagnostic.goto_next() end, "Previous" },
                l = { function() vim.lsp.diagnostic.show_line_diagnostics() end, "Line Diagnostics" },
                q = { function() vim.lsp.diagnostic.set_loclist() end, "Send to loclist"},
            },
            r = { function() vim.lsp.buf.rename() end, "Rename" },
            a = { function() vim.lsp.buf.code_action() end, "Code Action" },
            f = { function() vim.lsp.buf.formatting() end, "Format" },
            w = {
                name = "Workspace",
                a = { function() vim.lsp.buf.add_workspace_folder() end , "Add" },
                r = { function() vim.lsp.buf.remove_workspace_folder() end , "Remove" },
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
