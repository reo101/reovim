{:cmd [:haskell-language-server-wrapper
       ;; :nix
       ;; :run
       ;; :.#hls
       ;; :--
       :--lsp]
 :filetypes [:haskell
             :lhaskell]
 :root_markers [:*.cabal
                :stack.yaml
                :cabal.project
                :package.yaml
                :hie.yaml]
 :settings
  {:haskell
    {:formattingProvider :fourmolu
     :plugin
      {:ghcide-code-actions-fill-holes      {:globalOn true}
       :ghcide-completions                  {:globalOn true}
       :ghcide-hover-and-symbols            {:globalOn true}
       :ghcide-type-lenses                  {:globalOn true}
       :ghcide-code-actions-type-signatures {:globalOn true}
       :ghcide-code-actions-bindings        {:globalOn true}
       :ghcide-code-actions-imports-exports {:globalOn true}
       :eval                                {:globalOn true}
       :moduleName                          {:globalOn true}
       :pragmas                             {:globalOn true}
       :refineImports                       {:globalOn true}
       :importLens                          {:globalOn true}
       :class                               {:globalOn true}
       :tactics                             {:globalOn true} ;; wingman
       :hlint                               {:globalOn true}
       :haddockComments                     {:globalOn true}
       :retrie                              {:globalOn true}
       :rename                              {:globalOn true}
       :splic                               {:globalOn true}}}}}
