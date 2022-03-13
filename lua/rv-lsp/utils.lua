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
                p = { vim.diagnostic.goto_prev, "Previous" },
                n = { vim.diagnostic.goto_next, "Next" },
                l = { vim.diagnostic.open_float, "Line Diagnostics" },
                q = { vim.diagnostic.set_loclist, "Send to loclist" },
            },
            c = {
                name = "Codelens",
                r = { vim.lsp.codelens.run, "Run" },
                f = { vim.lsp.codelens.refresh, "Refresh" },
                s = { vim.lsp.codelens.save, "Save" },
                g = { vim.lsp.codelens.get, "Get" },
                a = { vim.lsp.codelens.display, "Display" },
            },
            r = { vim.lsp.buf.rename, "Rename" },
            a = { vim.lsp.buf.code_action, "Code Action" },
            f = { vim.lsp.buf.formatting, "Format" },
            s = { vim.lsp.buf.signature_help, "Signature Help" },
            w = {
                name = "Workspace",
                a = { vim.lsp.buf.add_workspace_folder, "Add" },
                r = { vim.lsp.buf.remove_workspace_folder, "Remove" },
                l = {
                    function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end,
                    "List",
                },
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
        K = {
            function()
                vim.lsp.buf.hover()
            end,
            "Hover",
        },
    }

    wk.register(directMappings, { mode = "n", prefix = "" })

    local motionMappings = {
        ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
        ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
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

    require("aerial").on_attach(client, bufnr)
    require("rv-lsp/signature").config()
end

local lsp_on_init = function(client)
    vim.notify("Language Server Client successfully started!", "info", {
        title = client.name,
    })
end

local lsp_capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem = {
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = {
            valueSet = { 1 },
        },
        documentationFormat = {
            "markdown",
        },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }

    return capabilities
end)()

local lsp_override_handlers = function()
    local border = "single"

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(
            vim.lsp.handlers.hover,
            {
                border = border,
            }
        )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = border,
        }
    )
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = {
                prefix = "",
                spacing = 0,
                source = "always", -- Or "if_many"
            },
            signs = true,
            underline = true,
            update_in_insert = false, -- update diagnostics insert mode
            severity_sort = false,
        }
    )

    if require("globals").custom.lsp_progress == "notify" then
        -------------------------------
        -- LSP Progress notification --
        -------------------------------
        local client_notifs = {}

        local spinner_frames = {
            "◜",
            "◠",
            "◝",
            "◞",
            "◡",
            "◟",
        }

        -- local spinner_frames = {
        --     "⣾",
        --     "⣽",
        --     "⣻",
        --     "⢿",
        --     "⡿",
        --     "⣟",
        --     "⣯",
        --     "⣷",
        -- }

        local function update_spinner(client_id, token)
            local notif_data = client_notifs[client_id][token]
            if notif_data and notif_data.spinner then
                local new_spinner = (notif_data.spinner + 1) % #spinner_frames
                local new_notif = vim.notify(nil, nil, {
                    hide_from_history = true,
                    icon = spinner_frames[new_spinner],
                    replace = notif_data.notification,
                })
                client_notifs[client_id][token] = {
                    notification = new_notif,
                    spinner = new_spinner,
                }
                vim.defer_fn(function()
                    update_spinner(client_id, token)
                end, 100)
            end
        end

        local function format_title(title, client)
            return client.name .. (#title > 0 and ": " .. title or "")
        end

        local function format_message(message, percentage)
            return (percentage and percentage .. "%\t" or "") .. (message or "")
        end

        local function lsp_progress_notification(_, result, ctx)
            local client_id = ctx.client_id
            local val = result.value
            if val.kind then
                if not client_notifs[client_id] then
                    client_notifs[client_id] = {}
                end
                local notif_data = client_notifs[client_id][result.token]
                if val.kind == "begin" then
                    local message = format_message(val.message, val.percentage)
                    local notification = vim.notify(message, "info", {
                        title = format_title(
                            val.title,
                            vim.lsp.get_client_by_id(client_id)
                        ),
                        icon = spinner_frames[1],
                        timeout = false,
                        hide_from_history = true,
                    })
                    client_notifs[client_id][result.token] = {
                        notification = notification,
                        spinner = 1,
                    }
                    update_spinner(client_id, result.token)
                elseif val.kind == "report" and notif_data then
                    local new_notif = vim.notify(
                        format_message(val.message, val.percentage),
                        "info",
                        {
                            replace = notif_data.notification,
                            hide_from_history = false,
                        }
                    )
                    client_notifs[client_id][result.token] = {
                        notification = new_notif,
                        spinner = notif_data.spinner,
                    }
                elseif val.kind == "end" and notif_data then
                    local new_notif = vim.notify(
                        val.message and format_message(val.message)
                            or "Complete",
                        "info",
                        {
                            icon = "",
                            replace = notif_data.notification,
                            timeout = 3000,
                        }
                    )
                    client_notifs[client_id][result.token] = {
                        notification = new_notif,
                    }
                end
            end
        end

        vim.lsp.handlers["$/progress"] = lsp_progress_notification

        -- Capture real implementation of function that sets signs
        local orig_set_signs = vim.lsp.diagnostic.set_signs
        local set_signs_limited =
            function(diagnostics, bufnr, client_id, sign_ns, opts)
                -- -- original func runs some checks, which I think is worth doing
                -- -- but maybe overkill
                -- if not diagnostics then
                --     diagnostics = diagnostic_cache[bufnr][client_id]
                -- end

                -- early escape
                if not diagnostics then
                    return
                end

                -- Work out max severity diagnostic per line
                local max_severity_per_line = {}
                for _, d in pairs(diagnostics) do
                    if max_severity_per_line[d.range.start.line] then
                        local current_d =
                            max_severity_per_line[d.range.start.line]
                        if d.severity < current_d.severity then
                            max_severity_per_line[d.range.start.line] = d
                        end
                    else
                        max_severity_per_line[d.range.start.line] = d
                    end
                end

                -- map to list
                local filtered_diagnostics = {}
                for _, v in pairs(max_severity_per_line) do
                    table.insert(filtered_diagnostics, v)
                end

                -- call original function
                orig_set_signs(
                    filtered_diagnostics,
                    bufnr,
                    client_id,
                    sign_ns,
                    opts
                )
            end
        vim.lsp.diagnostic.set_signs = set_signs_limited
    end

    local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
    }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

M.lsp_mappings = lsp_mappings
M.lsp_on_attach = lsp_on_attach
M.lsp_on_init = lsp_on_init
M.lsp_capabilities = lsp_capabilities
M.lsp_override_handlers = lsp_override_handlers

return M
