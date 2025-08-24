(fn after []
  (let [java  (require :java)
        lspconfig (require :lspconfig)
        dk (require :def-keymaps)
        {: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities} (require :rv-config.lsp.utils)
        ;; jdtls-find-root (. (require :jdtls.setup) :find_root)
        config {;; :cmd [:jdtls]
                :on_init lsp-on-init
                :init_options {:bundles {}}
                :settings {:java {:signatureHelp   {:enabled true}
                                  :contentProvider {:preferred :fernflower}
                                  :runtimes [{:name "Nix Java"
                                              :path "/nix/store/1szb66mzgy1r9sl1ihhksqzxvsrs3xv8-graalvm-ce-21.0.2"
                                              :default true}]}}
                ;; :root_dir (jdtls-find-root [:.git
                ;;                             :build.xml
                ;;                             :pom.xml
                ;;                             :mvnw
                ;;                             :settings.gradle
                ;;                             :settings.gradle.kts
                ;;                             :gradlew
                ;;                             :build.gradle
                ;;                             :build.gradle.kts])
                :on_attach lsp-on-attach
                :capabilities lsp-capabilities}]
    (java.setup)
    (lspconfig.jdtls.setup config)

    (dk :n
        {:l {:group :LSP
             :j {:group :Java
                 :r [java.test.run_current_class    "Run Current Class"]
                 :R [java.test.debug_current_class  "Debug Current Class"]
                 :m [java.test.run_current_method   "Run Current Method"]
                 :M [java.test.debug_current_method "Debug Current Method"]
                 :v [java.test.view_last_report     "View Last Report"]}}}
        {:prefix :<leader>})))

{:src "https://github.com/nvim-java/nvim-java"
 :data {:dependencies [:nvim-java/lua-async-await
                       :nvim-java/nvim-java-core
                       :nvim-java/nvim-java-test
                       :nvim-java/nvim-java-dap
                       :MunifTanjim/nui.nvim
                       :neovim/nvim-lspconfig
                       :mfussenegger/nvim-dap]
        :ft     ["java"]
        : after
        :enabled false}}
