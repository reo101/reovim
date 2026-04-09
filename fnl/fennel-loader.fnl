;;; Custom Fennel loader
;;; Finds and injects the custom Fennel fork with `#_` discard reader macro support.
;;; Used by both `.nfnl.fnl` and `bootstrap-nfnl.fnl`.

(local dev-fennel-path (.. vim.env.HOME "/Projects/Home/Fennel/Fennel"))

;;; State

(local specials-registry {})
(local macro-registry {})
(local fennel-module-prefixes
       [:fennel
        :nfnl.fennel
        :conjure.aniseed.deps.fennel
        :conjure.aniseed.fennel
        :conjure.nfnl.fennel])
(local fennel-submodules
       [:compiler
        :parser
        :specials
        :utils
        :view
        :repl
        :friend
        :binary])

;;; Internal Helpers

(fn find-nix-fennel-path []
  "Find Fennel installed via Nix in PATH, returns lua module path or nil"
  (let [fennel-bin (vim.fn.exepath :fennel)]
    (when (and fennel-bin (not= fennel-bin ""))
      (let [resolved (vim.fn.resolve fennel-bin)
            store-path (resolved:match "^(.*/[^/]+)/bin/fennel$")]
        (when store-path
          (let [lua-path (.. store-path "/share/lua/5.1")]
            (when (= 1 (vim.fn.isdirectory lua-path))
              lua-path)))))))

(fn has-discard-support? [fennel-path]
  "Test if Fennel at `fennel-path` supports `#_` discard reader macro"
  (let [test-path (.. fennel-path "/?.lua")
        saved-path package.path]
    (set package.path (.. test-path ";" package.path))
    (let [(ok fennel) (pcall require :fennel)]
      (set package.path saved-path)
      (when ok
        (each [k _ (pairs package.loaded)]
          (when (k:match "^fennel%.?")
            (tset package.loaded k nil))))
      (when ok
        (let [(eval-ok result) (pcall fennel.eval "(+ 1 #_2 3)")]
          (and eval-ok (= result 4)))))))

(fn find-custom-fennel []
  "Find custom Fennel with `#_` support: dev path first, then Nix PATH"
  (if (and (= 1 (vim.fn.isdirectory dev-fennel-path))
           (has-discard-support? dev-fennel-path))
      dev-fennel-path
      (let [nix-path (find-nix-fennel-path)]
        (when (and nix-path (has-discard-support? nix-path))
          nix-path))))

;;; Module Management

(fn fennel-module-key? [k]
  (when (= (type k) :string)
    (accumulate [match? false
                 _ prefix (ipairs fennel-module-prefixes)]
      (or match?
          (= k prefix)
          (vim.startswith k (.. prefix "."))))))

(fn sync-fennel-submodules! [prefix]
  (each [_ sub (ipairs fennel-submodules)]
    (let [standard-key (.. "fennel." sub)
          target-key (.. prefix "." sub)
          mod (. package.loaded standard-key)]
      (when mod
        (tset package.loaded target-key mod)))))

(fn purge-fennel-modules []
  "Remove all fennel modules from `package.loaded` and `package.preload`"
  (each [_ tbl (ipairs [:loaded :preload])]
    (each [k _ (pairs (. package tbl))]
      (when (fennel-module-key? k)
        (tset (. package tbl) k nil)))))

(fn sync-fennel-modules [fennel]
  "Synchronize all known Fennel module prefixes to one instance"
  (let [f (or fennel package.loaded.fennel)]
    (when (and f (= (type f) :table))
      (each [_ sub (ipairs fennel-submodules)]
        (pcall require (.. "fennel." sub)))
      (each [_ prefix (ipairs fennel-module-prefixes)]
        (tset package.loaded prefix f)
        (sync-fennel-submodules! prefix)))))

;;; Macro/Special Injection

(fn patch-table [t registry]
  "Inject registry aliases into a table (e.g. specials or macros)"
  (when (and (= (type t) :table) (= (type registry) :table))
    (each [name target (pairs registry)]
      (let [val (or (. t target) target)]
        (when (and val (not (. t name)))
          (tset t name val))))
    true))

(fn patch-scope [scope]
  (when (= (type scope) :table)
    (patch-table (?. scope :specials) specials-registry)
    (patch-table (?. scope :macros) macro-registry)
    scope))

(fn patch-specials-module []
  (let [(ok specials) (pcall require :fennel.specials)]
    (when (and ok (= (type specials) :table))
      (patch-table specials specials-registry))))

(fn apply-registries []
  "Patch the canonical compiler/specials tables in place"
  (let [(ok-compiler compiler) (pcall require :fennel.compiler)]
    (when ok-compiler
      (patch-scope (?. compiler :scopes :global))
      (patch-scope (?. compiler :scopes :compiler))))
  (patch-specials-module))

(fn merge-registry! [registry defs]
  (when (= (type defs) :table)
    (each [name value (pairs defs)]
      (tset registry name
            (if (and (= (type value) :table) (not= (. value :clone) nil))
                (or (. value :value) (. value :clone))
                value)))))

(fn registry-snapshot [registry]
  (let [copy {}]
    (each [name value (pairs (or registry {}))]
      (tset copy name value))
    copy))

(fn register-macro-defs [defs]
  "Register one normalized defs table: `{:specials {...} :macros {...}}`"
  (merge-registry! specials-registry defs.specials)
  (merge-registry! macro-registry defs.macros)
  (apply-registries))

(fn registered-defs []
  {:specials (registry-snapshot specials-registry)
   :macros (registry-snapshot macro-registry)})

(fn nfnl-output-lua-path []
  (let [nfnl-lua-dir (.. (vim.fn.stdpath :data) "/nfnl/lua")]
    (.. nfnl-lua-dir "/?.lua;" nfnl-lua-dir "/?/init.lua")))

(fn prepend-package-path! [path-prefix]
  (when (not (: package.path :match (vim.pesc path-prefix)))
    (set package.path (.. path-prefix ";" package.path))))

(fn ensure-runtime-plugin! [plugin-name]
  "Bootstrap-time helper for opt plugins needed before `packages.fnl` runs."
  (pcall vim.cmd.packadd {:args [plugin-name]}))

(fn runtime-file [plugin-name file-name]
  (ensure-runtime-plugin! plugin-name)
  (let [candidates (vim.api.nvim_get_runtime_file file-name true)
        preferred-pattern (.. "/" (vim.pesc plugin-name) "/" (vim.pesc file-name) "$")]
    (or (accumulate [found-path nil
                     _ path (ipairs candidates)]
          (or found-path
              (and (: path :match preferred-pattern)
                   path)))
        (. candidates 1))))

(fn module-name->source-path [module-name ?config-dir]
  (let [rel-path (.. "fnl/" (module-name:gsub "%." "/") ".fnl")
        runtime-paths (vim.api.nvim_get_runtime_file rel-path true)]
    (or (let [config-dir ?config-dir]
          (when config-dir
            (let [config-path (.. config-dir "/" rel-path)]
              (when (= 1 (vim.fn.filereadable config-path))
                config-path))))
        (. runtime-paths 1)
        (let [config-path (.. (vim.fn.stdpath :config) "/" rel-path)]
          (when (= 1 (vim.fn.filereadable config-path))
            config-path)))))

(fn macro-defs? [defs]
  (and (= (type defs) :table)
       (or (= (type defs.specials) :table)
           (= (type defs.macros) :table))))

(fn ensure-source-preload! [module-name ?config-dir]
  (when (not (package.searchpath module-name package.path))
    (let [source-path (module-name->source-path module-name ?config-dir)]
      (when source-path
        (tset package.preload module-name
              (fn []
                (let [fennel (require :fennel)
                      (ok defs) (pcall fennel.dofile source-path)]
                  (if ok
                      defs
                      (error (.. "fennel-loader: Failed to preload "
                                 module-name
                                 " from "
                                 source-path
                                 ": "
                                 defs)
                             0)))))))))

(fn load-macro-module-from-source [module-name ?config-dir]
  (let [source-path (module-name->source-path module-name ?config-dir)]
    (when source-path
      (let [fennel (require :fennel)
            (ok defs) (pcall fennel.dofile source-path)]
        (when (and ok (macro-defs? defs))
          (tset package.loaded module-name defs)
          defs)))))

(fn register-macros-from-module [module-name ?config-dir]
  (tset package.loaded module-name nil)
  (let [(ok defs) (pcall require module-name)]
    (let [resolved-defs (if (and ok (macro-defs? defs))
                            defs
                            (load-macro-module-from-source module-name ?config-dir))]
      (if resolved-defs
          (register-macro-defs resolved-defs)
          (vim.notify (.. "fennel-loader: Failed to load macros from module "
                          module-name
                          ": "
                          (tostring defs))
                      vim.log.levels.WARN)))))

(fn fallback-macro-modules-available [?config-dir]
  (let [modules ["macros.jp" "macros.typed-fennel"]]
    (each [_ module-name (ipairs modules)]
      (ensure-source-preload! module-name ?config-dir))
    modules))

(fn inject-all-global-macros [?config-dir]
  "Inject the compiled config macro hub universally"
  (prepend-package-path! (nfnl-output-lua-path))
  (let [fallback? (not (package.searchpath "macros.init" package.path))
        modules (if fallback?
                    (fallback-macro-modules-available ?config-dir)
                    ["macros.init" "macros.jp"])]
    (when (not fallback?)
      (ensure-source-preload! "macros.init" ?config-dir))
    (ensure-source-preload! "macros.typed-fennel" ?config-dir)
    (each [_ module-name (ipairs modules)]
      (when (or (= module-name "macros.init")
                (= module-name "macros.jp")
                (= module-name "macros.typed-fennel"))
        (tset package.loaded module-name nil)))
    (if fallback?
        (each [_ module-name (ipairs modules)]
          (register-macros-from-module module-name ?config-dir))
        (register-macros-from-module "macros.init" ?config-dir))))

;;; Path Setup

(fn typed-fennel-plugin-parent []
  (let [init-macros-path (runtime-file "typed-fennel" "init-macros.fnl")]
    (when init-macros-path
      (vim.fs.dirname (vim.fs.dirname init-macros-path)))))

(fn typed-fennel-path []
  (let [plugin-parent (typed-fennel-plugin-parent)]
    (when plugin-parent
      (.. plugin-parent "/?/init.fnl"))))

(fn typed-fennel-macro-path []
  (let [plugin-parent (typed-fennel-plugin-parent)]
    (when plugin-parent
      (.. plugin-parent "/?/init-macros.fnl"))))

(fn config-fennel-path [config-dir]
  (.. config-dir "/?.fnl;"
      config-dir "/?/init.fnl;"
      config-dir "/fnl/?.fnl;"
      config-dir "/fnl/?/init.fnl"))

(fn prepend-search-path! [fennel key path-prefix]
  (let [current (. fennel key)]
    (when (and (= (type current) :string)
               (not (: current :match (vim.pesc path-prefix))))
      (tset fennel key (.. path-prefix ";" current)))))

(fn setup-fennel-paths [fennel ?config-dir]
  (let [config-dir (or ?config-dir (vim.fn.stdpath :config))]
    (when (= (type fennel) :table)
      (prepend-search-path! fennel :path (config-fennel-path config-dir))
      (let [typed-fennel-path (typed-fennel-path)]
        (when typed-fennel-path
          (prepend-search-path! fennel :path typed-fennel-path)))
      (let [macro-path (typed-fennel-macro-path)]
        (when macro-path
          (prepend-search-path! fennel "macro-path" macro-path))))))

(fn inject-custom-fennel []
  "Find, load, and inject custom Fennel into `package.loaded`"
  (let [fennel-path (find-custom-fennel)]
    (when (not fennel-path)
      (error (.. "Custom Fennel with #_ support not found.\n"
                 "Checked: " dev-fennel-path "\n"
                 "Also checked PATH for Nix-built fennel.")))
    (purge-fennel-modules)
    (when (not (: package.path :match (vim.pesc fennel-path)))
      (set package.path (.. fennel-path "/?.lua;" package.path)))
    (let [fennel (require :fennel)]
      (sync-fennel-modules fennel)
      (apply-registries)
      fennel)))

{: sync-fennel-modules
 : inject-custom-fennel
 : inject-all-global-macros
 : registered-defs
 : typed-fennel-macro-path
 : setup-fennel-paths}
