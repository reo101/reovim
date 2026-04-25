;;; Declarative tree-sitter registry shared by runtime, lockfile sync, and Nix.

(fn copy-list [xs]
  (if xs
      (icollect [_ x (ipairs xs)] x)
      []))

(fn sorted-list [xs]
  (let [sorted (copy-list xs)]
    (table.sort sorted)
    sorted))

(fn grammar-plugin-name [lang]
  (.. "tree-sitter-" (tostring lang)))

(fn grammar-filetypes [grammar]
  (or grammar.filetypes
      (and grammar.filetype [grammar.filetype])
      []))

(local grammars
  {:move
    {:install_info {:url "https://github.com/reo101/tree-sitter-move"
                    :files [:src/parser.c]
                    :branch :update-parser}
     :filetypes [:move]
     :categories [:treesitter_extra]}
   :fennel
   {:install_info {:url (if false
                          (vim.fn.expand "~/Projects/Home/Fennel/tree-sitter-fennel")
                          "https://github.com/reo101/tree-sitter-fennel")
                   :files [:src/parser.c :src/scanner.c]
                   :branch :feat/discard
                   :generate true}
    :filetypes [:fennel]}
   :jj_template
   {:install_info {:url "https://github.com/reo101/tree-sitter-jj_template"
                    :files [:src/parser.c]
                    :branch :master}
    :filetypes [:jj_template]
    :categories [:treesitter_extra]}
   :uci
   {:install_info {:url "https://github.com/reo101/tree-sitter-uci"
                   :generate true
                   :branch :master}
    :filetypes [:uci]
    :categories [:treesitter_extra]}
   :noir
   {:install_info {:url "https://github.com/hhamud/tree-sitter-noir"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :main}
    :filetypes [:noir]
    :categories [:treesitter_extra]}
   :crisp
   {:install_info {:url "https://github.com/reo101/tree-sitter-crisp"
                   :files [:src/parser.c]
                   :branch :master}
    :categories [:treesitter_extra]}
   :xml
   {:install_info {:url "https://github.com/dorgnarg/tree-sitter-xml"
                   :files [:src/parser.c]
                   :branch :main
                   :generate true}
    :categories [:treesitter_extra]}
   :http
   {:install_info {:url "https://github.com/NTBBloodbath/tree-sitter-http"
                   :files [:src/parser.c]
                   :branch :main}
    :categories [:treesitter_extra]}
   :norg_meta
   {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-meta"
                   :files [:src/parser.c]
                   :branch :main}
    :categories [:writing]}
   :norg_table
   {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-table"
                   :files [:src/parser.c]
                   :branch :main}
    :categories [:writing]}
   :brainfuck
   {:install_info {:url "https://github.com/reo101/tree-sitter-brainfuck"
                   :files [:src/parser.c]
                   :branch :master}
    :categories [:treesitter_extra]}
   :hy
   {:install_info {:url "https://github.com/kwshi/tree-sitter-hy"
                   :files [:src/parser.c]
                   :branch :main}
    :filetypes [:hy]
    :categories [:treesitter_extra]}
   :awk
   {:install_info {:url "https://github.com/Beaglefoot/tree-sitter-awk"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :master}
    :categories [:treesitter_extra]}
   :nu
   {:install_info {:url "https://github.com/nushell/tree-sitter-nu"
                   :files [:src/parser.c]
                   :branch :main}
    :filetypes [:nu]
    :categories [:treesitter_extra]}
   :comment
   {:install_info {:url "https://github.com/OXY2DEV/tree-sitter-comment"
                   :files [:src/parser.c :src/scanner.c]
                   :branch :main
                   :revision "87bb8707b694e7d9820947f21be36d6ce769e5cc"
                   :generate true}}})

(local extra-language-aliases
  {:markdown [:octo]
   :typst [:typc]})

(fn grammar-rev [grammar]
  (let [info (or grammar.install_info {})]
    (or info.revision
        (.. "refs/heads/" (or info.branch "master")))))

(fn grammar-lockfile-entry [lang grammar]
  (let [info (or grammar.install_info {})]
    {:src info.url
     :rev (grammar-rev grammar)
     :files info.files}))

(local grammar-groups
  (let [groups {}]
    (each [lang grammar (pairs grammars)]
      (each [_ category (ipairs (or grammar.categories []))]
        (when (not (. groups category))
          (tset groups category []))
        (table.insert (. groups category) (grammar-plugin-name lang))))
    (each [_ names (pairs groups)]
      (table.sort names))
    groups))

(fn nix-export []
  (let [grammar-export {}
        alias-export {}]
    (each [lang grammar (pairs grammars)]
      (tset grammar-export (tostring lang)
            {:categories (sorted-list (or grammar.categories []))
             :filetypes (sorted-list (grammar-filetypes grammar))}))
    (each [lang filetypes (pairs extra-language-aliases)]
      (tset alias-export (tostring lang) (sorted-list filetypes)))
    {:grammarGroups grammar-groups
     :grammars grammar-export
     :languageAliases alias-export}))

{:extra-language-aliases extra-language-aliases
 :grammar-filetypes grammar-filetypes
 :grammar-groups grammar-groups
 :grammar-lockfile-entry grammar-lockfile-entry
 :grammar-plugin-name grammar-plugin-name
 :grammar-rev grammar-rev
 :grammars grammars
 :nix-export nix-export}
