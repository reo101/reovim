local M = {}

_G.takovai_jdtls = function()
    -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
    local config = {
        -- The command that starts the language server
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        -- cmd = {
        --
        --     -- 💀
        --     "java", -- or "/path/to/java11_or_newer/bin/java"
        --     -- depends on if `java` is in your $PATH env variable and if it points to the right version.
        --
        --     "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        --     "-Dosgi.bundles.defaultStartLevel=4",
        --     "-Declipse.product=org.eclipse.jdt.ls.core.product",
        --     "-Dlog.protocol=true",
        --     "-Dlog.level=ALL",
        --     "-Xms1g",
        --     "--add-modules=ALL-SYSTEM",
        --     "--add-opens", "java.base/java.util=ALL-UNNAMED",
        --     "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        --
        --     -- 💀
        --     "-jar", "/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
        --     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        --     -- Must point to the                                                     Change this to
        --     -- eclipse.jdt.ls installation                                           the actual version
        --
        --
        --     -- 💀
        --     "-configuration", "/usr/share/java/jdtls/config_linux",
        --     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        --     -- Must point to the                      Change to one of `linux`, `win` or `mac`
        --     -- eclipse.jdt.ls installation            Depending on your system.
        --
        --
        --     -- 💀
        --     -- See `data directory configuration` section in the README
        --     "-data", "/path/to/unique/per/project/workspace/folder"
        -- },

        cmd = { "jdtls" },

        on_attach = require("rv-lsp.utils").lsp_on_attach,
        on_init = require("rv-lsp.utils").lsp_on_init,
        capabilities = require("rv-lsp.utils").lsp_capabilities,

        -- 💀
        -- This is the default if not provided, you can remove it. Or adjust as needed.
        -- One dedicated LSP server & client will be started per unique root_dir
        -- root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew"}),
        root_dir = require("jdtls.setup").find_root({
            -- Git
            ".git",
            -- Single-module projects
            "build.xml",           -- ant
            "pom.xml",             -- maven
            "mvnw",                -- maven
            "settings.gradle",     -- gradle
            "settings.gradle.kts", -- gradle
            "gradlew",             -- gradle
            -- Multi-module projects
            "build.gradle",        -- gradle
            "build.gradle.kts",    -- gradle
        }),

        -- Here you can configure eclipse.jdt.ls specific settings
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- for a list of options
        settings = {
            java = {
            }
        },

        -- Language server `initializationOptions`
        -- You need to extend the `bundles` with paths to jar files
        -- if you want to use additional eclipse.jdt.ls plugins.
        --
        -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
        --
        -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
        init_options = {
            bundles = {}
        },
    }

    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    require("jdtls").start_or_attach(config)

    local wk = require("which-key")

    local mappings = {
        l = {
            name = "LSP",
            i = { require("jdtls").organize_imports, "Organize Imports" },
            t = { require("jdtls").test_class, "Test Class" },
            n = { require("jdtls").test_nearest_method, "Test Nearest Method" },
            e = { require("jdtls").extract_variable, "Extract Variable" },
        },
    }

    local visualMappings = {
        l = {
            name = "LSP",
            e = { function() require("jdtls").extract_variable(true) end, "Extract Variable" },
            m = { function() require("jdtls").extract_method(true) end, "Extract Method" },
        },
    }

    wk.register(mappings, { prefix = "<leader>" })
    wk.register(visualMappings, { mode = "v", prefix = "<leader>" })

end

M.config = function()

    vim.cmd([[autocmd FileType java lua takovai_jdtls()]])

end

return M
