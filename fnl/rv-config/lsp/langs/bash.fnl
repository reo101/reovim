(fn after []
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:bash-language-server
                   :start]
             :cmd_env {:GLOB_PATTERN "*@(.sh|.inc|.bash|.command)"}
             :filetypes [:sh
                         :bash
                         :zsh]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir [])
             :single_file_support true}]
    ((. (. (require :lspconfig) :bashls) :setup) opt)))

{: after}
