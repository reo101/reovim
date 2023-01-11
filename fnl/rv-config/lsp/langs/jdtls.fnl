;; TODO: Fennelize

(local M {})

(set _G.takovai_jdtls
     (fn []
       (let [config {:on_init (. (require :rv-config.lsp.utils) :lsp_on_init)
                     :init_options {:bundles {}}
                     :settings {:java {:signatureHelp   {:enabled true}
                                       :contentProvider {:preferred :fernflower}}}
                     :root_dir ((. (require :jdtls.setup) :find_root) {1 :.git
                                                                       2 :build.xml
                                                                       3 :pom.xml
                                                                       4 :mvnw
                                                                       5 :settings.gradle
                                                                       6 :settings.gradle.kts
                                                                       7 :gradlew
                                                                       8 :build.gradle
                                                                       9 :build.gradle.kts})
                     :on_attach (. (require :rv-config.lsp.utils) :lsp_on_attach)
                     :cmd {1 :jdtls}
                     :capabilities (. (require :rv-config.lsp.utils) :lsp_capabilities)}]
         ((. (require :jdtls) :start_or_attach) config)
         (local wk (require :which-key))
         (local mappings
                {:l {:name :LSP
                     :t {1 (. (require :jdtls) :test_class) 2 "Test Class"}
                     :n {1 (. (require :jdtls) :test_nearest_method)
                         2 "Test Nearest Method"}
                     :i {1 (. (require :jdtls) :organize_imports)
                         2 "Organize Imports"}
                     :e {1 (. (require :jdtls) :extract_variable)
                         2 "Extract Variable"}}})
         (local visual-mappings
                {:l {:name :LSP
                     :m {1 (fn []
                             ((. (require :jdtls) :extract_method) true))
                         2 "Extract Method"}
                     :e {1 (fn []
                             ((. (require :jdtls) :extract_variable) true))
                         2 "Extract Variable"}}})
         (wk.register mappings {:prefix :<leader>})
         (wk.register visual-mappings {:prefix :<leader> :mode :v}))))

(set M.config
     (fn []
       (vim.cmd "autocmd FileType java lua takovai_jdtls()")))

M
