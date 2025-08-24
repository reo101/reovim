(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:ocamllsp]
             :filetypes [:ocaml
                         :ocaml.menhir
                         :ocaml.interface
                         :ocaml.ocamllex
                         :reason
                         :dune]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:*.opam
                          :esy.json
                          :package.json
                          :dune-project
                          :dune-workspace]
                         true)}]
    ((. (require :lspconfig) :ocamllsp :setup) opt)))

{: after}
