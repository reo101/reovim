(import-macros
  {: rv
   : ||>
   : forieach
   : imap
   : dbg!}
  :init-macros)

;; (local lazy (require :lazy))

(fn preload [path]
  ;; NOTE: nfnl output directory is set up in <./bootstrap-nfnl.fnl>
  ;; Scans only ONE level deep - nested specs use (require (.. ... :.submodule))
  (fn scan-modules [dir-path mod-prefix results]
    (each [entry (vim.fs.dir dir-path)]
      ;; Skip hidden/template entries
      (when (not (entry:match "^__"))
        (let [entry-path (vim.fs.joinpath dir-path entry)
              entry-type (vim.uv.fs_stat entry-path)
              full-mod-name (.. mod-prefix "." entry)]
          (when entry-type
            ;; Two cases for modules:
            ;; 1. Directory with init.lua -> mod-prefix.dirname
            ;; 2. Loose .lua file at THIS level only (not in subdirs) -> mod-prefix.filename
            (if (= entry-type.type :directory)
                ;; Case 1: Directory with init.lua
                (let [init-path (vim.fs.joinpath entry-path :init.lua)
                      init-stat (vim.uv.fs_stat init-path)]
                  (when (and init-stat (= init-stat.type :file))
                    (table.insert results full-mod-name)))
                ;; Case 2: Loose .lua file - but only at top level of current dir
                ;; Files in subdirectories are helpers, not modules
                (let [mod-name (entry:match "^(.*)%.lua$")]
                  (when mod-name
                    (table.insert results (.. mod-prefix "." mod-name)))))))))
    results)

  ;; Determine search paths based on environment
  ;; Use rv-nix.is-nix to detect Nix environment (works at runtime)
  ;; In Nix builds, compiled Lua files are in config's lua/ directory
  ;; At runtime (non-Nix), they're in stdpath('data')/nfnl/lua/
  (local rv-nix-module (require :rv-nix))
  (local is-nix? rv-nix-module.is-nix)

  ;; Get the directory of this script (works for both Nix and non-Nix)
  ;; debug.getinfo returns source as @/path/to/file.lua, strip the @
  (local this-file (-> (debug.getinfo 1 :S) (. :source) (: :sub 2)))
  (local this-dir (vim.fn.fnamemodify this-file ":h"))
  ;; Go up one level from fnl/ to get the config root
  (local config-dir (vim.fn.fnamemodify this-dir ":h"))

  (local nfnl-dir (vim.fs.joinpath (vim.fn.stdpath :data) :nfnl :lua))

  ;; Build list of directories to search
  ;; Always search config/lua/ (has Nix-compiled files + bootstrap files)
  ;; Also search nfnl-dir at runtime for dynamically compiled files (non-Nix)
  (local search-paths
    (if is-nix?
        ;; Nix: only search config's lua/ directory (Nix store is read-only, no runtime compilation)
        [(vim.fs.joinpath config-dir :lua path)]
        ;; Non-Nix: search both nfnl output (at nfnl/lua/<path>) and config's lua/
        ;; Note: use nfnl-dir/path to avoid double prefix (rv-config/rv-config)
        [(vim.fs.joinpath nfnl-dir path)
         (vim.fs.joinpath config-dir :lua path)]))

  (var all-module-names [])

  ;; Scan all search paths and collect module names
  (each [_ base-path (ipairs search-paths)]
    (local exists (= 1 (vim.fn.isdirectory base-path)))
    (when exists
      (scan-modules base-path path all-module-names)))

  ;; Deduplicate module names (same module might exist in multiple search paths)
  (local unique-module-names [])
  (local seen {})
  (each [_ mod-name (ipairs all-module-names)]
    (when (not (. seen mod-name))
      (tset seen mod-name true)
      (table.insert unique-module-names mod-name)))
  (set all-module-names unique-module-names)

  ;; Ensure lua/ directories are in package.path for requiring
  ;; NOTE: Only add the BASE lua directories, not the specific path subdirectories.
  ;; The module names returned by scan-modules include the full path (e.g., "rv-config.which-key"),
  ;; so they will resolve correctly via the base patterns. Adding path-specific patterns
  ;; would cause require("which-key") to incorrectly match rv-config/which-key/init.lua.
  (each [_ base-path (ipairs search-paths)]
    ;; Strip the path suffix to get the base lua directory
    (let [base-lua-dir (vim.fn.fnamemodify base-path ":h")  ;; e.g., .../nfnl/lua/rv-config -> .../nfnl/lua
          lua-path (.. base-lua-dir "/?.lua")
          init-path (.. base-lua-dir "/?/init.lua")]
      (when (not (: package.path :match (vim.pesc lua-path)))
        (set package.path (.. lua-path ";" package.path)))
      (when (not (: package.path :match (vim.pesc init-path)))
        (set package.path (.. init-path ";" package.path)))))

  ;; Require all found modules and return results
  (local results
    (icollect [_ mod-name (pairs all-module-names)]
      ;; Extra safety: skip if mod-name is somehow nil
      (when mod-name
        (let [(ok result) (pcall require mod-name)]
          (if ok
              result
              (do
                (vim.notify (.. "preload: Failed to load " mod-name ": " (tostring result))
                            vim.log.levels.WARN)
                nil))))))

  results)

(fn flatten [seq ?res]
  (local res (or ?res []))
  (if (vim.islist seq)
    (each [_ v (pairs seq)]
      (flatten v res))
    ;; else (atom)
    (tset res
          (+ (length res) 1)
          seq))
  res)

;; Load rv-nix and register lze handler BEFORE loading plugin specs
;; This ensures autoload proxies can find plugins via lze's on_require
(local rv-nix (require :rv-nix))
(rv-nix.setup {:non-nix-value true})
(rv-nix.register-lze-handler)

(local rv-config-mods
  (-> :rv-config
      preload
      flatten))

;; Filter out disabled specs only
(local specs
  (-> rv-config-mods
      vim.iter
      (: :filter #(not= (?. $1 :data :enabled) false))
      (: :totable)
      flatten))

;; Helper to extract plugin name from src URL
;; Matches vim.pack's algorithm: strip .git suffix, then take last path component
;; e.g. "https://github.com/nvim-lua/plenary.nvim" -> "plenary.nvim"
(fn src->name [src]
  (when src
    (-> src
        (: :gsub "%.git$" "")   ; Strip .git suffix (vim.pack does this first)
        (: :match "[^/]+$"))))   ; Take last path component after final /

;; When running under Nix, use lze directly with :packadd
;; instead of vim.pack.add which downloads plugins
(if rv-nix.is-nix
  (let [lze (require :lze)
        ;; Get nix plugin list to filter specs
        nix-plugins (or (rv-nix.get {} :plugins :lazy) {})
        nix-start (or (rv-nix.get {} :plugins :start) {})]
    ;; Transform specs: flatten data fields to root for lze consumption
    ;; lze needs on_require, event, after, etc. at the root level
    (each [_ spec (ipairs specs)]
      (when spec.src
        (let [name (src->name spec.src)]
          (when (and name (. nix-plugins name))
            ;; Replace src with name for lze and flatten data fields
            (tset spec :name name)
            (tset spec :src nil)
            ;; Merge data fields into root level so lze can see them
            (when spec.data
              (each [k v (pairs spec.data)]
                (tset spec k v)))))))
    ;; Load via lze which will use :packadd for plugins in opt/
    (lze.load specs))
  ;; Non-Nix: use vim.pack.add to download plugins
  ;; lze handles ALL lazy loading (event, on_require, after, etc.)
  ;; vim.pack.add just downloads and makes plugins available via :packadd
  (let [group (vim.api.nvim_create_augroup
                :VimPackBuilds
                {:clear false})
        ;; Transform ALL specs for lze: extract data fields to root level
        ;; This gives lze access to after, event, on_require, etc.
        ;; Use src->name to match vim.pack's name derivation exactly
        lze-specs (-> specs
                       vim.iter
                       (: :filter #(. $1 :src))  ; Only specs with src
                       (: :map #(let [name (src->name $1.src)]
                                  (vim.tbl_extend :force
                                    {:name name
                                     :src $1.src}
                                    (or $1.data {}))))
                       (: :totable))
        ;; All plugin specs for vim.pack.add (just for downloading)
        ;; Use same transformed specs but lze will handle loading
        download-specs lze-specs]
    (vim.api.nvim_create_autocmd
      :User
      {: group
       :pattern :PackChanged
       :callback #(let [p $.data
                         build-task (?. p :spec :data :build)]
                     (when (and (not= p.kind :delete)
                                (= (type build-task) :function))
                       (pcall build-task p)))})
    ;; Register ALL specs with lze FIRST
    ;; lze handles lazy loading (event, on_require, after hooks)
    (when (> (length lze-specs) 0)
      (let [lze (require :lze)]
        (lze.load lze-specs)))
    ;; Download all plugins via vim.pack.add
    ;; lze has already registered handlers, so it will manage loading
    (vim.pack.add download-specs {:confirm false})))

;; (vim.print
;;   {: plugin-list
;;    : nix-lazy-path
;;    :plugins [main-plugins
;;              (preload :rv-config)]
;;    : opts})

;; (cats.lazy-setup
;;   plugin-list
;;   nix-lazy-path
;;   [main-plugins
;;    (preload :rv-config)]
;;   opts)

;; (lazy.setup
;;   [main-plugins
;;    (preload :rv-config)]
;;   opts)
