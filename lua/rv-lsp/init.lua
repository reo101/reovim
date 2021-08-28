local servers = {
    clangd = require("rv-lsp.langs.clangd").config,
    lua = require("rv-lsp.langs.lua").config,
    latex = require("rv-lsp.langs.latex").config,
    diagnosticls = require("rv-lsp.langs.diagnosticls").config,
    python = require("rv-lsp.langs.python").config,
}

local function setup_servers()
    for name, opt in pairs(servers) do
        if type(opt) == "function" then
            opt()
        else
            local client = require("lspconfig")[name]
            client.setup(vim.tbl_extend("force", {
                flags = { debounce_text_changes = 150 },
                on_attach = require("rv-lsp.utils").lsp_on_attach,
                on_init = require("rv-lsp.utils").lsp_on_init,
                capabilities = require("rv-lsp.utils").lsp_capabilities,
            }, opt))
        end
    end
end

setup_servers()

require("rv-lsp.utils").lsp_override_handlers()
