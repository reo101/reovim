(fn config []
  (let [servers {:latex      (. (require :rv-config.lsp.langs.latex)      :config)
                 :sqls       (. (require :rv-config.lsp.langs.sqls)       :config)
                 :zig        (. (require :rv-config.lsp.langs.zig)        :config)
                 :tsserver   (. (require :rv-config.lsp.langs.tsserver)   :config)
                 :bash       (. (require :rv-config.lsp.langs.bash)       :config)
                 :null_ls    (. (require :rv-config.lsp.langs.null-ls)    :config)
                 :json       (. (require :rv-config.lsp.langs.json)       :config)
                 :clangd     (. (require :rv-config.lsp.langs.clangd)     :config)
                 :docker     (. (require :rv-config.lsp.langs.docker)     :config)
                 :nim        (. (require :rv-config.lsp.langs.nim)        :config)
                 :racket     (. (require :rv-config.lsp.langs.racket)     :config)
                 :python     (. (require :rv-config.lsp.langs.python)     :config)
                 :haskell    (. (require :rv-config.lsp.langs.haskell)    :config)
                 :cmake      (. (require :rv-config.lsp.langs.cmake)      :config)
                 :emmet_ls   (. (require :rv-config.lsp.langs.emmet-ls)   :config)
                 :go         (. (require :rv-config.lsp.langs.go)         :config)
                 :erlang     (. (require :rv-config.lsp.langs.erlang)     :config)
                 :lua        (. (require :rv-config.lsp.langs.lua)        :config)
                 :clojure    (. (require :rv-config.lsp.langs.clojure)    :config)
                 :angular    (. (require :rv-config.lsp.langs.angular)    :config)
                 :prolog     (. (require :rv-config.lsp.langs.prolog)     :config)
                 :terraform  (. (require :rv-config.lsp.langs.terraform)  :config)
                 :nix        (. (require :rv-config.lsp.langs.nix)        :config)
                 :yaml       (. (require :rv-config.lsp.langs.yaml)       :config)
                 :r          (. (require :rv-config.lsp.langs.r)          :config)
                 :xml        (. (require :rv-config.lsp.langs.xml)        :config)
                 :purescript (. (require :rv-config.lsp.langs.purescript) :config)
                 :fennel     (. (require :rv-config.lsp.langs.fennel)     :config)
                 :solidity   (. (require :rv-config.lsp.langs.solidity)   :config)
                 :php        (. (require :rv-config.lsp.langs.php)        :config)
                 :ocaml      (. (require :rv-config.lsp.langs.ocaml)      :config)
                 :pest       (. (require :rv-config.lsp.langs.pest)       :config)}]
    (fn setup-servers []
      (each [name opt (pairs servers)]
        (if (= (type opt) :function)
          (opt)
          (let [client (. (require :lspconfig) name)]
            (client.setup (vim.tbl_extend :force
                                          {:flags {:debounce_text_changes 150}
                                           :capabilities (. (require :rv-config.lsp.utils)
                                                            :lsp-capabilities)
                                           :on_init (. (require :rv-config.lsp.utils)
                                                       :lsp-on-init)
                                           :on_attach (. (require :rv-config.lsp.utils)
                                                         :lsp-on-attach)}
                                          opt))))))

    (setup-servers)
    ((. (require :rv-config.lsp.utils) :lsp-override-handlers))))

{: config}
