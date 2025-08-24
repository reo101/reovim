(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:yaml-language-server
                   :--stdio]
             :filetypes [:yaml
                         :yaml.docker-compose]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         []
                         true)
             :single_file_support true
             :settings {:redhat {:telemetry {:enabled false}}
                        :yaml {:schemas {:https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json "/.gitlab-ci.yml"}}}}]
    ((. (. (require :lspconfig) :yamlls) :setup) opt)))

{: after}
