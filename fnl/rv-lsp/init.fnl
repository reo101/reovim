(fn config []
  (let [servers {:latex     (. (require :rv-lsp.langs.latex)     :config)
                 :sqls      (. (require :rv-lsp.langs.sqls)      :config)
                 :zig       (. (require :rv-lsp.langs.zig)       :config)
                 :tsserver  (. (require :rv-lsp.langs.tsserver)  :config)
                 :bash      (. (require :rv-lsp.langs.bash)      :config)
                 :null_ls   (. (require :rv-lsp.langs.null-ls)   :config)
                 :json      (. (require :rv-lsp.langs.json)      :config)
                 :clangd    (. (require :rv-lsp.langs.clangd)    :config)
                 :docker    (. (require :rv-lsp.langs.docker)    :config)
                 :nim       (. (require :rv-lsp.langs.nim)       :config)
                 :racket    (. (require :rv-lsp.langs.racket)    :config)
                 :python    (. (require :rv-lsp.langs.python)    :config)
                 :haskell   (. (require :rv-lsp.langs.haskell)   :config)
                 :cmake     (. (require :rv-lsp.langs.cmake)     :config)
                 :emmet_ls  (. (require :rv-lsp.langs.emmet-ls)  :config)
                 :go        (. (require :rv-lsp.langs.go)        :config)
                 :erlang    (. (require :rv-lsp.langs.erlang)    :config)
                 :lua       (. (require :rv-lsp.langs.lua)       :config)
                 :clojure   (. (require :rv-lsp.langs.clojure)   :config)
                 :angular   (. (require :rv-lsp.langs.angular)   :config)
                 :prolog    (. (require :rv-lsp.langs.prolog)    :config)
                 :terraform (. (require :rv-lsp.langs.terraform) :config)
                 :nix       (. (require :rv-lsp.langs.nix)       :config)
                 :r         (. (require :rv-lsp.langs.r)         :config)}]
    (fn setup-servers []
      (each [name opt (pairs servers)]
        (if (= (type opt) :function)
          (opt)
          (let [client (. (require :lspconfig) name)]
            (client.setup (vim.tbl_extend :force
                                          {:flags {:debounce_text_changes 150}
                                           :capabilities (. (require :rv-lsp.utils)
                                                            :lsp-capabilities)
                                           :on_init (. (require :rv-lsp.utils)
                                                       :lsp-on-init)
                                           :on_attach (. (require :rv-lsp.utils)
                                                         :lsp-on-attach)}
                                          opt))))))

    (setup-servers)
    ((. (require :rv-lsp.utils) :lsp-override-handlers))))

{: config}
