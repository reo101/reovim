local M = {}

M.config = function()
    local servers = {
        clangd = require("rv-lsp.langs.clangd").config,
        cmake = require("rv-lsp.langs.cmake").config,
        lua = require("rv-lsp.langs.lua").config,
        latex = require("rv-lsp.langs.latex").config,
        null_ls = require("rv-lsp.langs.null-ls").config,
        python = require("rv-lsp.langs.python").config,
        sqls = require("rv-lsp.langs.sqls").config,
        racket = require("rv-lsp.langs.racket").config,
        haskell = require("rv-lsp.langs.haskell").config,
        -- rust = require("rv-lsp.langs.rust").config,
        go = require("rv-lsp.langs.go").config,
        tsserver = require("rv-lsp.langs.tsserver").config,
        -- java = require("rv-lsp.langs.java").config,
        bash = require("rv-lsp.langs.bash").config,
        erlang = require("rv-lsp.langs.erlang").config,
        zig = require("rv-lsp.langs.zig").config,
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
end

return M
