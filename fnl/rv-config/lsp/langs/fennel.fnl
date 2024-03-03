(fn config-fennel-language-server []
  (let [configs     (require :lspconfig.configs)
        server-name :fennel-language-server]
    (tset configs server-name
          {:default_config {:single_file_support true
                            :settings {:fennel {:diagnostics {:globals [:vim]}
                                                :workspace {:library (vim.api.nvim_list_runtime_paths)}}}
                            :cmd [:fennel-language-server]
                            :filetypes [:fennel]
                            :root_dir ((. (require :lspconfig) :util :root_pattern) :fnl)}})
    (let [{: lsp-on-init
           : lsp-on-attach
           : lsp-capabilities
           : lsp-root-dir} (require :rv-config.lsp.utils)
          opt {:cmd [:fennel-language-server]
               :filetypes [:fennel]
               :on_init lsp-on-init
               :on_attach lsp-on-attach
               :capabilities lsp-capabilities
               :settings {:fennel {:diagnostics {:globals [:vim :bit]}
                                   :workspace   {:library (vim.api.nvim_list_runtime_paths)}}}
               :root_dir (lsp-root-dir
                           [:*.fnl])
               :single_file_support true}]
      ((. (require :lspconfig) :fennel-language-server :setup) opt))))

(fn config-fennel-ls []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:fennel-ls]
             :filetypes [:fennel]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :settings {:fennel-ls
                         {:fennel-path
                            (table.concat
                              ["./?.fnl"
                               "./?/init.fnl"
                               "src/?.fnl"
                               "src/?/init.fnl"]
                              ";")
                          :macro-path
                            (table.concat
                              ["./?.fnl"
                               "./?/init-macros.fnl"
                               "./?/init.fnl"
                               "src/?.fnl"
                               "src/?/init-macros.fnl"
                               "src/?/init.fnl"]
                              ";")
                          :extra-globals
                            (table.concat [:vim])}}
             :root_dir (lsp-root-dir
                         []
                         true)
             :single_file_support true}]
    ((. (. (require :lspconfig) :fennel_ls) :setup) opt)))

{:config config-fennel-ls}
