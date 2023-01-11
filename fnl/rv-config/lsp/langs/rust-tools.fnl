(fn config []
   (let [{: lsp-on-init
          : lsp-on-attach
          : lsp-capabilities
          : lsp-root-dir} (require :rv-config.lsp.utils)
         opt {:server {:capabilities lsp-capabilities
                       :on_init lsp-on-init
                       :on_attach lsp-on-attach
                       :settings {:rust-analyzer {:procMacro {:enable true}
                                                  :checkOnSave {:command :clippy}}
                                  :assist {:importGranularity :module
                                           :importPrefix :self}
                                  :cargo {:loadOutDirsFromCheck true}}}
              :dap {:adapter {:type :executable
                              :name :rt_lldb
                              :command :lldb-vscode}}
              :tools {:inlay_hints {:other_hints_prefix "=> "
                                    :max_len_align_padding 1
                                    :only_current_line_autocmd :CursorHold
                                    :right_align_padding 7
                                    :parameter_hints_prefix "<- "
                                    :highlight :Comment
                                    :max_len_align false
                                    :only_current_line false
                                    :right_align false
                                    :show_parameter_hints true}
                      :runnables {:use_telescope true}
                      :debuggables {:use_telescope true}
                      :autoSetHints true
                      :hover_actions {:auto_focus false
                                      :border [["╭" :FloatBorder]
                                               ["─" :FloatBorder]
                                               ["╮" :FloatBorder]
                                               ["│" :FloatBorder]
                                               ["╯" :FloatBorder]
                                               ["─" :FloatBorder]
                                               ["╰" :FloatBorder]
                                               ["│" :FloatBorder]]}
                      :crate_graph {:backend :x11
                                    :full true
                                    :output nil}}}]
     ((. (require :rust-tools) :setup) opt)))

{: config}
