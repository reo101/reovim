(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-lsp.utils)
        opt {:cmd [:haskell-language-server-wrapper
                   :--lsp]
             :filetypes [:haskell
                         :lhaskell]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:*.cabal
                          :stack.yaml
                          :cabal.project
                          :package.yaml
                          :hie.yaml]) 
             :lspinfo (fn []
                        (local extra {})

                        (fn on-stdout [_ data _]
                          (local version (. data 1))
                          (table.insert extra (.. "version:   " version)))

                        (local opts
                               {:cwd (. (require :lspconfig.config) :cwd)
                                :on_stdout on-stdout
                                :stdout_buffered true})
                        (local chanid
                               (vim.fn.jobstart {1 (. (. (require :lspconfig.config)
                                                         :cmd)
                                                      1)
                                                 2 :--version}
                                                opts))
                        (vim.fn.jobwait {1 chanid})
                        extra)
             :single_file_support true}]
    ((. (. (require :lspconfig) :hls) :setup) opt)))

{: config}
