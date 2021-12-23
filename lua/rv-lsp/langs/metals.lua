local M = {}

M.config = function()

    _G.setup_metals = function()

        local metals_config = require("metals").bare_config()

        metals_config.settings = {
            showImplicitArguments = true,
        }

        metals_config.init_options.statusBarProvider = "on"

        metals_config.on_attach = function(client, bufnr)
            require("rv-lsp.utils").lsp_on_attach(client, bufnr)
            require("rv-lsp.utils").lsp_on_init(client)
            require("metals").setup_dap()
        end

        -- metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        --     virtual_text = { prefix = "" },
        -- })

        vim.cmd [[
            hi! link LspCodeLens CursorColumn
            hi! link LspReferenceText CursorColumn
            hi! link LspReferenceRead CursorColumn
            hi! link LspReferenceWrite CursorColumn
        ]]

        local wk = require("which-key")

        local mappings = {
            ["fm"] = { require("telescope").extensions.metals.commands, "Metals Commands" },
        }

        local visualMappings = {
            ["K"] = { require("metals").type_of_range, "Type of Range" },

        }

        wk.register(mappings, { prefix = "<leader>" })
        wk.register(visualMappings, { mode = "v", prefix = "" })

        require("metals").initialize_or_attach(metals_config)

    end

    vim.cmd [[
        augroup lsp
        au!
        au FileType scala,sbt lua _G.setup_metals()
        augroup end
    ]]

end

return M
