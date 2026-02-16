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

    ;; Grab the parser config table so we can inject our grammars into it
    (local parser-configs (require :nvim-treesitter.parsers))

    ;; My custom grammars - these get merged into nvim-treesitter's parser table
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
                       :branch :main}
        :filetype :nu}
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
        (tset parser-configs lang conf)
        (when conf.filetype
          (vim.treesitter.language.register lang [conf.filetype]))))

    (register-custom-parsers)

    (vim.api.nvim_create_autocmd :User
      {:pattern :TSUpdate
       :callback register-custom-parsers
       :desc "Register custom tree-sitter parsers"})

    ;; Setup moved to the top-level nvim-treesitter module on main
    (let [treesitter (require :nvim-treesitter)]
      (treesitter.setup {}))

    (fn ensure-nvim-treesitter-runtimepath []
      ;; nvim-treesitter/main ships bundled queries under runtime/queries.
      ;; Make sure that runtime dir is on rtp so query discovery can find them.
      (let [lua-files (vim.api.nvim_get_runtime_file "lua/nvim-treesitter/init.lua" true)
            lua-path (. lua-files 1)]
        (if lua-path
            (let [plugin-root (: lua-path :gsub "/lua/nvim%-treesitter/init%.lua$" "")
                  runtime-dir (vim.fs.joinpath plugin-root "runtime")]
              (when (and (= 1 (vim.fn.isdirectory runtime-dir))
                         (not (vim.tbl_contains (vim.opt.runtimepath:get) runtime-dir)))
                (vim.opt.runtimepath:append runtime-dir))
              plugin-root)
            nil)))

    (local nvim-treesitter-root (ensure-nvim-treesitter-runtimepath))

    (fn prefer-single-parser-provider [plugin-root]
      ;; Canonical strategy: use rtp ordering to prefer one parser provider.
      ;; De-prioritize nvim-treesitter's bundled parser/ so core runtime parsers
      ;; win when both exist, while still keeping nvim-treesitter available.
      (when (and plugin-root
                 (= 1 (vim.fn.isdirectory (vim.fs.joinpath plugin-root "parser")))
                 (vim.tbl_contains (vim.opt.runtimepath:get) plugin-root))
        (vim.opt.runtimepath:remove plugin-root)
        (vim.opt.runtimepath:append plugin-root)))

    (prefer-single-parser-provider nvim-treesitter-root)

    (let [fennel-highlights (require :rv-config.treesitter.fennel-highlights)]
      (fennel-highlights.setup))

    (fn warn-missing-highlights-query [lang]
      ;; Keep fallback warnings opt-in: some environments intentionally rely on regex syntax.
      (when vim.g.reovim_treesitter_warn_missing_highlights_query
        (vim.notify_once
          (.. "treesitter: no usable highlights query for "
              (tostring lang)
              "; keeping regex syntax highlighting active")
          vim.log.levels.WARN)))

    (fn highlights-query-usable? [lang]
      (if (not lang)
          false
          (let [(ok query) (pcall vim.treesitter.query.get lang :highlights)
                capture-count (if (and query query.captures)
                                (length query.captures)
                                0)
                usable? (and ok (> capture-count 0))]
            (when (not usable?)
              (warn-missing-highlights-query lang))
            usable?)))

    (fn notify-highlight-short-circuit [lang]
      (vim.notify_once
        (.. "treesitter: short-circuiting highlight attach for "
            (tostring lang)
            " because highlights query is unusable; keeping regex syntax active")
        vim.log.levels.WARN))

    (fn stop-buffer-treesitter-highlights [bufnr]
      (let [highlighter (. vim.treesitter.highlighter.active bufnr)]
        (when highlighter
          ;; Stop TS highlights only; keep parser consumers (e.g. rainbow-delimiters) intact.
          (pcall #(highlighter:destroy)))))

    (fn normal-file-buffer? [bufnr]
      (and bufnr
           (vim.api.nvim_buf_is_loaded bufnr)
           (= (. vim.bo bufnr :buftype) "")
           (= (vim.fn.buflisted bufnr) 1)
           (not= (vim.api.nvim_buf_get_name bufnr) "")))

    (local previous-buffer-syntax {})
    (fn set-buffer-regex-syntax [bufnr ft enabled?]
      ;; Disable regex syntax when TS highlights are active to avoid startup flash.
      ;; Re-enable regex syntax only for fallback/no-query buffers.
      (let [bo (. vim.bo bufnr)
            current-syntax (. bo :syntax)
            previous-syntax (. previous-buffer-syntax bufnr)]
        (if enabled?
            (do
              (let [syntax-to-restore (or previous-syntax ft "")]
                (when (and (= current-syntax "")
                           (not= syntax-to-restore ""))
                  (tset bo :syntax syntax-to-restore)))
              (tset previous-buffer-syntax bufnr nil))
            (when (not= current-syntax "")
              (tset previous-buffer-syntax bufnr current-syntax)
              (tset bo :syntax "")))))

    (local fallback-parser-refresh-tick {})
    (fn refresh-buffer-parser-for-fallback [bufnr lang]
      ;; With no highlights query, :edit can clear TS extmarks from parser consumers.
      ;; Re-parse once per changedtick to restore consumers without per-enter churn.
      (let [changedtick (vim.api.nvim_buf_get_changedtick bufnr)
            last-tick (. fallback-parser-refresh-tick bufnr)]
        (when (not= changedtick last-tick)
          (tset fallback-parser-refresh-tick bufnr changedtick)
          (let [(ok parser) (pcall vim.treesitter.get_parser bufnr lang)]
            (when ok
              (pcall #(parser:parse)))))))

    (fn ensure-buffer-highlights [bufnr ?ft]
      (when (normal-file-buffer? bufnr)
        (var ft (or ?ft (. vim.bo bufnr :filetype)))
        (when (= ft "")
          (set ft (or (vim.filetype.match {:buf bufnr}) ""))
          (when (not= ft "")
            (tset (. vim.bo bufnr) :filetype ft)))
        (when (not= ft "")
          (let [lang (or (vim.treesitter.language.get_lang ft) ft)]
            (if (highlights-query-usable? lang)
                (do
                  (set-buffer-regex-syntax bufnr ft false)
                  ;; :edit can detach the TS highlighter for a reused buffer.
                  ;; Reattach on demand when we notice it's missing.
                  (when (not (. vim.treesitter.highlighter.active bufnr))
                    (pcall vim.treesitter.start bufnr lang)))
                ;; Keep regex syntax when no highlights query exists for this language.
                (do
                  (notify-highlight-short-circuit lang)
                  (set-buffer-regex-syntax bufnr ft true)
                  (stop-buffer-treesitter-highlights bufnr)
                  (refresh-buffer-parser-for-fallback bufnr lang)))))))

    (local pending-highlight-repair {})
    (fn queue-buffer-highlights [bufnr ?ft]
      ;; Run repair in the next loop tick to beat post-:edit detach timing.
      (when bufnr
        (tset pending-highlight-repair bufnr true)
        (vim.schedule
          (fn []
            (when (. pending-highlight-repair bufnr)
              (tset pending-highlight-repair bufnr nil)
              (ensure-buffer-highlights bufnr ?ft))))))

    (local repair-group
      (vim.api.nvim_create_augroup :ReovimTreesitterRepair {:clear true}))

    ;; Disable regex syntax as early as possible for normal file buffers.
    ;; Fallback path will re-enable it for languages without usable TS highlights.
    (vim.api.nvim_create_autocmd [:BufReadPre :BufNewFile]
      {:group repair-group
       :callback
       (fn [ev]
         (when (normal-file-buffer? ev.buf)
           (let [bufname (vim.api.nvim_buf_get_name ev.buf)
                 ft (or (. vim.bo ev.buf :filetype)
                        (vim.filetype.match {:filename bufname})
                        (vim.filetype.match {:buf ev.buf})
                        "")]
             (set-buffer-regex-syntax ev.buf ft false))))
       :desc "Disable regex syntax early; fallback reenables when TS highlights are unavailable"})

    ;; Validate highlight attach/fallback state for languages as they appear.
    (vim.api.nvim_create_autocmd :FileType
      {:group repair-group
       :callback
       (fn [ev]
         (queue-buffer-highlights ev.buf ev.match))
       :desc "Repair treesitter highlight state for buffers"})

    ;; :edit and other read paths can drop a previously active TS highlighter.
    ;; Re-check on buffer reads/enters so highlighting persists across reloads.
    (vim.api.nvim_create_autocmd [:BufReadPost :BufWinEnter :BufEnter]
      {:group repair-group
       :callback
       (fn [ev]
         (queue-buffer-highlights ev.buf))
       :desc "Repair treesitter highlight state for buffers"})

    ;; Catch up any buffers that opened before we loaded (for late-loaded plugins)
    (each [_ bufnr (ipairs (vim.api.nvim_list_bufs))]
      (when (normal-file-buffer? bufnr)
        (queue-buffer-highlights bufnr)))

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
