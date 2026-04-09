;;; Shared custom treesitter grammar registry.
;;; Keep this module pure enough to reuse from runtime setup and lockfile sync.

(local custom-grammars
  {:move
    {:install_info {:url "https://github.com/reo101/tree-sitter-move"
                    :files [:src/parser.c]
                    :branch :update-parser}
     :filetype :move}
   :fennel
   {:install_info {:url (if false
                          (vim.fn.expand "~/Projects/Home/Fennel/tree-sitter-fennel")
                          "https://github.com/reo101/tree-sitter-fennel")
                   :files [:src/parser.c :src/scanner.c]
                   :branch :feat/discard
                   :generate true}
    :filetype :fennel}
   :jj_template
   {:install_info {:url "https://github.com/reo101/tree-sitter-jj_template"
                    :files [:src/parser.c]
                    :branch :master}
    :filetype :jj_template}
   :uci
   {:install_info {:url "https://github.com/reo101/tree-sitter-uci"
                   :generate true
                   :branch :master}
    :filetype :uci}
   :noir
   {:install_info {:url "https://github.com/hhamud/tree-sitter-noir"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :main}
    :filetype :noir}
   :crisp
   {:install_info {:url "https://github.com/reo101/tree-sitter-crisp"
                   :files [:src/parser.c]
                   :branch :master}}
   :xml
   {:install_info {:url "https://github.com/dorgnarg/tree-sitter-xml"
                   :files [:src/parser.c]
                   :branch :main
                   :generate true}}
   :http
   {:install_info {:url "https://github.com/NTBBloodbath/tree-sitter-http"
                   :files [:src/parser.c]
                   :branch :main}}
   :norg_meta
   {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-meta"
                   :files [:src/parser.c]
                   :branch :main}}
   :norg_table
   {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-table"
                   :files [:src/parser.c]
                   :branch :main}}
   :brainfuck
   {:install_info {:url "https://github.com/reo101/tree-sitter-brainfuck"
                   :files [:src/parser.c]
                   :branch :master}}
   :hy
   {:install_info {:url "https://github.com/kwshi/tree-sitter-hy"
                   :files [:src/parser.c]
                   :branch :main}
    :filetype :hy}
   :awk
   {:install_info {:url "https://github.com/Beaglefoot/tree-sitter-awk"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :master}}
   :nu
   {:install_info {:url "https://github.com/nushell/tree-sitter-nu"
                   :files [:src/parser.c]
                   :branch :main}
    :filetype :nu}
   :comment
   {:install_info {:url "https://github.com/OXY2DEV/tree-sitter-comment"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :main
                   :revision "87bb8707b694e7d9820947f21be36d6ce769e5cc"
                   :generate true}}})

(fn register-custom-parsers []
  (local parser-configs (require :nvim-treesitter.parsers))
  (each [lang conf (pairs custom-grammars)]
    (tset parser-configs lang conf)
    (when conf.filetype
      (vim.treesitter.language.register lang [conf.filetype]))))

{:custom-grammars custom-grammars
 :register-custom-parsers register-custom-parsers}
