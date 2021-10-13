local M = {}

local lsp_mappings = function()
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
                p = { vim.lsp.diagnostic.goto_prev, "Previous" },
                n = { vim.lsp.diagnostic.goto_next, "Next" },
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
            d = { vim.lsp.buf.definition, "Definition" },
            D = { vim.lsp.buf.declaration, "Decaration" },
            y = { vim.lsp.buf.type_definition, "Type Definition" },
            r = { vim.lsp.buf.references, "References" },
            i = { vim.lsp.buf.implementation, "Implementation" },
        },
        K = { function() vim.lsp.buf.hover() end, "Hover" },
    }

    wk.register(directMappings, { mode = "n", prefix = "" })

    local motionMappings = {
        ["[d"] = { vim.lsp.diagnostic.goto_prev, "Previous Diagnostic" },
        ["]d"] = { vim.lsp.diagnostic.goto_next, "Next Diagnostic" },
    }

    wk.register(motionMappings, { mode = "n", prefix = "" })
    wk.register(motionMappings, { mode = "o", prefix = "" })
end

local lsp_on_attach = function(client, bufnr)
    lsp_mappings()

    if client.resolved_capabilities.code_lens then
        vim.cmd [[
        augroup CodeLens
            au!
            au InsertEnter,InsertLeave * lua vim.lsp.codelens.refresh()
        augroup END
        ]]
    end

    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
        augroup LSPDocumentHighlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]]
    end

    require("rv-lsp/signature").config()
    require("rv-lsp/kind").config()
end

local lsp_on_init = function(client)
    vim.notify("Language Server Client successfully started!", "info", {
        title = client.name,
    })
end

local lsp_capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.documentationFormat = {
        "markdown",
    }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport =
        true
    capabilities.textDocument.completion.completionItem.tagSupport = {
        valueSet = { 1 },
    }
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    return capabilities
end)()

local lsp_override_handlers = function()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            prefix = "",
            spacing = 0,
        },
        signs = true,
        underline = true,
        update_in_insert = false, -- update diagnostics insert mode
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    local signs = {
        Error = " ",
        Warning = " ",
        Hint = " ",
        Information = " ",
    }
    for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

M.lsp_mappings = lsp_mappings
M.lsp_on_attach = lsp_on_attach
M.lsp_on_init = lsp_on_init
M.lsp_capabilities = lsp_capabilities
M.lsp_override_handlers = lsp_override_handlers

return M
