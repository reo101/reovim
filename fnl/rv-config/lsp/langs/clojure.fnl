(fn config []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:clojure-lsp]
             :filetypes [:clojure
                         :edn]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:project.clj
                          :deps.edn
                          :build.boot
                          :shadow-cljs.edn])}]
    ((. (. (require :lspconfig) :clojure_lsp) :setup) opt)))

{: config}
