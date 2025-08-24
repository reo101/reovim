(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:cmake-language-server]
             :filetypes [:cmake]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:compile_commands
                          :build
                          :CMakeLists.txt
                          :cmake])
             :init_options {:buildDirectory :build}
             :formatter {:args {}
                         :exe :clang-format}
             :single_file_support true}]
    ((. (. (require :lspconfig) :cmake) :setup) opt)))

{: after}
