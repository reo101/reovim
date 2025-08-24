(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:OmniSharp]
             :filetypes [:cs
                         :vb]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:*.sln
                          :*.csproj
                          :omnisharp.json
                          :function.json]
                         true)
             :handlers
               (let [omnisharp-extended (require :omnisharp_extended)]
                 {:textDocument/definition     omnisharp-extended.definition_handler
                  :textDocument/typeDefinition omnisharp-extended.type_definition_handler
                  :textDocument/references     omnisharp-extended.references_handler
                  :textDocument/implementation omnisharp-extended.implementation_handler})
             :init_options {}
             :settings
               {:FormattingOptions
                 {;; Enables support for reading code style, naming convention and analyzer
                  ;; settings from .editorconfig.
                  :EnableEditorConfigSupport true
                  ;; Specifies whether 'using' directives should be grouped and sorted during
                  ;; document formatting.
                  :OrganizeImports nil}
                :MsBuild
                 {;; If true, MSBuild project system will only load projects for files that
                  ;; were opened in the editor. This setting is useful for big C# codebases
                  ;; and allows for faster initialization of code navigation features only
                  ;; for projects that are relevant to code that is being edited. With this
                  ;; setting enabled OmniSharp may load fewer projects and may thus display
                  ;; incomplete reference lists for symbols.
                  :LoadProjectsOnDemand nil}
                :RoslynExtensionsOptions
                 {;; Enables support for roslyn analyzers, code fixes and rulesets.
                  :EnableAnalyzersSupport nil
                  ;; Enables support for showing unimported types and unimported extension
                  ;; methods in completion lists. When committed, the appropriate using
                  ;; directive will be added at the top of the current file. This option can
                  ;; have a negative impact on initial completion responsiveness
                  ;; particularly for the first few completion sessions after opening a
                  ;; solution.
                  :EnableImportCompletion nil
                  ;; Only run analyzers against open files when 'enableRoslynAnalyzers' is
                  ;; true
                  :AnalyzeOpenDocumentsOnly nil}
                :Sdk
                 {;; Specifies whether to include preview versions of the .NET SDK when
                  ;; determining which version to use for project loading.
                  :IncludePrereleases true}}}]
    ((. (. (require :lspconfig) :omnisharp) :setup) opt)))

[{:src "https://github.com/Hoffs/omnisharp-extended-lsp.nvim"
  : after
  :ft [:cs :vb]}]
