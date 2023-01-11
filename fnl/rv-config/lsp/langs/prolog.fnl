(fn config []
  (local configs (require :lspconfig.configs))
  (local util (require :lspconfig.util))
  (local server_name :prolog_lsp)
  (tset configs server_name
        {:default_config {:cmd [:swipl
                                :-g
                                "use_module(library(lsp_server))."
                                :-g
                                "lsp_server:main"
                                :-t
                                :halt
                                "--"
                                :stdio]
                          :filetypes [:prolog]
                          :root_dir (util.root_pattern :pack.pl)}
         :docs {:description "https://github.com/jamesnvc/prolog_lsp Prolog Language Server"}})
  (let [{: lsp-on-init
         : lsp-on-attach
         : lsp-capabilities
         : lsp-root-dir} (require :rv-config.lsp.utils)
        opt {:cmd [:swipl
                   :-g
                   "use_module(library(lsp_server))."
                   :-g
                   "lsp_server:main"
                   :-t
                   :halt
                   "--"
                   :stdio]
             :filetypes [:prolog]
             :on_init lsp-on-init
             :on_attach lsp-on-attach
             :capabilities lsp-capabilities
             :root_dir (lsp-root-dir
                         [:pack.pl])}]
    ((. (. (require :lspconfig) :prolog_lsp) :setup) opt)
    (set vim.g.filetype_pl "prolog")))

{: config}
