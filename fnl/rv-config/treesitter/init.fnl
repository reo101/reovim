(import-macros
  {: dbg!}
  :init-macros)

(fn after []
  (let [dk (require :def-keymaps)]

    ;; setgsub! - gsub on captured node text, store in metadata
    ;; (#setgsub! metadata_key capture_idx pattern replacement)
    (vim.treesitter.query.add_directive
      :setgsub!
      (fn [matches _ts-pattern bufnr list metadata]
        (let [[_directive key capture_id pattern replacement] list]
          (tset metadata key
                (string.gsub
                  (vim.treesitter.get_node_text (. matches capture_id) bufnr
                    {:metadata (. metadata capture_id)})
                  pattern
                  replacement))))
      true)

    ;; extmark-gsub! - mark delimiter positions with extmarks
    ;; Pattern must capture (start_delim)(content)(end_delim)
    ;; Example: (#extmark-gsub! @bold "conceal" "" "^(%*%*)(.-)(%*%*)$")
    (local extmark-ns (vim.api.nvim_create_namespace :extmark-delims))
    (vim.treesitter.query.add_directive
      :extmark-gsub!
      (fn [matches _ts-pattern bufnr list _metadata]
        (let [[_directive capture_id prop value pattern] list
              match-data (. matches capture_id)
              node (if (vim.islist match-data) (. match-data 1) match-data)]
          (when node
            (let [text (vim.treesitter.get_node_text node bufnr)
                  (start_delim _content end_delim) (string.match text pattern)]
              (when (and start_delim end_delim)
                (let [(sr sc er ec) (node:range)
                      start_len (length start_delim)
                      end_len (length end_delim)]
                  (when (> start_len 0)
                    (vim.api.nvim_buf_set_extmark bufnr extmark-ns sr sc
                      {:end_row sr :end_col (+ sc start_len) prop value}))
                  (when (> end_len 0)
                    (vim.api.nvim_buf_set_extmark bufnr extmark-ns er (- ec end_len)
                      {:end_row er :end_col ec prop value}))))))))
      true)

    ;; Skip if any child contains one of these text values
    (vim.treesitter.query.add_predicate
      :has-no-child?
      (fn [matches _ts-pattern bufnr pred]
        (let [[_directive capture_id & not-wanted] pred
              [node] (. matches capture_id)]
          (not
            (faccumulate [any false i 0 (- (node:child_count) 1)]
              (let [child (node:child i)
                    child-text (vim.treesitter.get_node_text child bufnr)]
                (or any (vim.tbl_contains not-wanted child-text)))))))
      {:all true})

    ;; Prefer these compilers for building parsers
    (tset (require :nvim-treesitter.install) :compilers
          [:clang "zig cc" :gcc])

    ;; Grab the parser list so we can inject our grammars into it
    (local parsers (require :nvim-treesitter.parsers))
    (local list parsers.list)

    ;; My custom grammars - these get merged into nvim-treesitter's parser list
    ;; Also exported for the Nix lockfile generator to pick up
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
                        :branch :main}}
       :comment
        {:install_info {:url "https://github.com/OXY2DEV/tree-sitter-comment"
                        :files [:src/parser.c :src/scanner.c]
                        :branch :main
                        :revision "87bb8707b694e7d9820947f21be36d6ce769e5cc"
                        :generate true}}})

    ;; Stash in global so the Nix updater can find it without loading the whole module
    (tset _G :reovim/treesitter-grammars custom-grammars)

    (fn register-custom-parsers []
      (each [lang conf (pairs custom-grammars)]
        (tset list lang conf)
        (when conf.filetype
          (vim.treesitter.language.register lang [conf.filetype]))))

    (register-custom-parsers)

    (vim.api.nvim_create_autocmd :User
      {:pattern :TSUpdate
       :callback register-custom-parsers
       :desc "Register custom tree-sitter parsers"})

    ;; nvim-treesitter handles its own autocmd registration when you call setup
    (local configs (require :nvim-treesitter.configs))
    (configs.setup
      {:highlight {:enable true}
       :indent {:enable true}})

    ;; Catch up any buffers that opened before we loaded (for late-loaded plugins)
    (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
      (when (vim.api.nvim_buf_is_loaded bufnr)
        (let [ft (. vim.bo bufnr :filetype)]
          (when (and (not= ft "") (= (. vim.bo bufnr :buftype) ""))
            (pcall vim.treesitter.start bufnr)))))

    ;; <leader>t for T**r**eesitter stuff
    (let [mappings {:t {:group :Toggle
                        :r {:group :TreeSitter
                            :g [#(vim.cmd.InspectTree) :PlayGround]}}}]
      (dk :n mappings {:prefix :<leader>}))))

[{:src "https://github.com/mfussenegger/nvim-ts-hint-textobject"
  :data {:dep_of [:nvim-treesitter]}}
 {:src "https://github.com/OXY2DEV/tree-sitter-comment"
  :data {:dep_of [:nvim-treesitter]}}
 {:src "https://github.com/nvim-treesitter/nvim-treesitter"
  :data {:build ":TSUpdate"
         : after}}
 (require (.. ... :.rainbow))
 (require (.. ... :.context))]
