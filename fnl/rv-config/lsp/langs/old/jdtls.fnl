(local M {})

(fn takovai_jdtls []
  (let [jdtls  (require :jdtls)
        {: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities} (require :rv-config.lsp.utils)
        jdtls-find-root (. (require :jdtls.setup) :find_root)
        config {:on_init lsp-on-init
                :init_options {:bundles {}}
                :settings {:java {:signatureHelp   {:enabled true}
                                  :contentProvider {:preferred :fernflower}}}
                :root_dir (jdtls-find-root [:.git
                                            :build.xml
                                            :pom.xml
                                            :mvnw
                                            :settings.gradle
                                            :settings.gradle.kts
                                            :gradlew
                                            :build.gradle
                                            :build.gradle.kts])
                :on_attach lsp-on-attach
                :cmd [:jdtls]
                :capabilities lsp-capabilities}]
    (jdtls.start_or_attach config)
    (local wk (require :which-key))
    (local mappings
           {:l {:group :LSP
                :t [(jdtls.test_class 2 "Test Class")]
                :n [(jdtls.test_nearest_method)
                    "Test Nearest Method"]
                :i [(jdtls.organize_imports)
                    "Organize Imports"]
                :e [(jdtls.extract_variable)
                    "Extract Variable"]}})
    (local visual-mappings
           {:l {:group :LSP
                :m [#(jdtls.extract_method true)
                    "Extract Method"]
                :e [#(jdtls.extract_variable true)
                    "Extract Variable"]}})
    (wk.register mappings {:prefix :<leader>})
    (wk.register visual-mappings {:prefix :<leader> :mode :v})))

(set M.config
     (vim.api.nvim_create_autocmd
       :FileType
       {:pattern  :java
        :callback #(takovai_jdtls)}))

M
