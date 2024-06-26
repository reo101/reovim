(fn config []
   (let [{: lsp-on-init
          : lsp-on-attach
          : lsp-capabilities
          : lsp-root-dir} (require :rv-config.lsp.utils)
         executors (require :rustaceanvim.executors)
         opt {:tools
                {:executor executors.toggleterm}
              :server
                {:capabilities lsp-capabilities
                 :on_init lsp-on-init
                 :on_attach lsp-on-attach
                 :settings {:rust-analyzer {:procMacro {:enable true}
                                            :checkOnSave {:command :clippy}
                                            :trace {:server :verbose}}
                            :assist {:importGranularity :module
                                     :importPrefix :self}
                            :cargo {:loadOutDirsFromCheck true
                                    :features :all}}}
              :dap {}}]
     (tset vim.g :rustaceanvim opt)))

{1 :mrcjkb/rustaceanvim
 :tag :4.22.10
 :ft [:rust]
 : config}
