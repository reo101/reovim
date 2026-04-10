;;; Side-effect-free plugin spec discovery shared by `packages.fnl` and `nix.lockfile`.

(fn scan-modules [dir-path mod-prefix results]
  "Scan one level of Fennel modules under `dir-path`."
  (each [entry (vim.fs.dir dir-path)]
    ;; Skip hidden/template entries.
    (when (not (entry:match "^__"))
      (let [entry-path (vim.fs.joinpath dir-path entry)
            entry-type (vim.uv.fs_stat entry-path)
            full-mod-name (.. mod-prefix "." entry)]
        (when entry-type
          (if (= entry-type.type :directory)
              (let [init-path (vim.fs.joinpath entry-path :init.fnl)
                    init-stat (vim.uv.fs_stat init-path)]
                (when (and init-stat (= init-stat.type :file))
                  (table.insert results full-mod-name)))
              (let [mod-name (entry:match "^(.*)%.fnl$")]
                (when mod-name
                  (table.insert results (.. mod-prefix "." mod-name)))))))))
  results)

(fn find-config-root [dir]
  (when (and dir (not= dir ""))
    (if (= 1 (vim.fn.isdirectory (vim.fs.joinpath dir :fnl)))
        dir
        (let [parent (vim.fs.dirname dir)]
          (when (and parent (not= parent dir))
            (find-config-root parent))))))

(fn config-dir []
  ;; Prefer the packaged config root when this module is loaded from compiled Lua.
  ;; Walk upward until we find a sibling `fnl/` tree so store paths like
  ;; `/nix/store/.../lua/packages/specs.lua` resolve back to the packaged root.
  ;; Fall back to stdpath("config") for the local nfnl cache under data/nfnl/.
  (let [this-file (-> (debug.getinfo 1 :S) (. :source) (: :sub 2))
        config-root (find-config-root (vim.fn.fnamemodify this-file ":h"))]
    (or config-root (vim.fn.stdpath :config))))

(fn fennel-module-paths [path]
  (local config-root (config-dir))
  [(vim.fs.joinpath config-root :fnl path)])

(fn require-paths [path]
  (local rv-nix (require :rv-nix))
  (local config-root (config-dir))
  (local nfnl-dir (vim.fs.joinpath (vim.fn.stdpath :data) :nfnl :lua))
  (if rv-nix.is-nix
      [(vim.fs.joinpath config-root :lua path)]
      [(vim.fs.joinpath nfnl-dir path)
       (vim.fs.joinpath config-root :lua path)]))

(fn unique-module-names [module-names]
  (let [seen {}
        unique []]
    (each [_ mod-name (ipairs module-names)]
      (when (and mod-name (not (. seen mod-name)))
        (tset seen mod-name true)
        (table.insert unique mod-name)))
    unique))

(fn ensure-package-paths! [base-paths]
  ;; Only add the base Lua directories; module names already include the full prefix.
  (each [_ base-path (ipairs base-paths)]
    (let [base-lua-dir (vim.fn.fnamemodify base-path ":h")
          lua-path (.. base-lua-dir "/?.lua")
          init-path (.. base-lua-dir "/?/init.lua")]
      (when (not (: package.path :match (vim.pesc lua-path)))
        (set package.path (.. lua-path ";" package.path)))
      (when (not (: package.path :match (vim.pesc init-path)))
        (set package.path (.. init-path ";" package.path))))))

(fn load-modules [path]
  "Require all modules discovered from Fennel source under a module prefix."
  (local source-paths (fennel-module-paths path))
  (local base-paths (require-paths path))
  (var module-names [])

  (each [_ source-path (ipairs source-paths)]
    (when (= 1 (vim.fn.isdirectory source-path))
      (scan-modules source-path path module-names)))

  (set module-names (unique-module-names module-names))
  (ensure-package-paths! base-paths)

  (icollect [_ mod-name (pairs module-names)]
    (when mod-name
      (let [(ok result) (pcall require mod-name)]
        (if ok
            result
            (do
              (vim.notify
                (.. "packages.specs: Failed to load "
                    mod-name
                    ": "
                    (tostring result))
                vim.log.levels.WARN)
              nil))))))

(fn flatten [seq ?res]
  (local res (or ?res []))
  (if (vim.islist seq)
      (each [_ v (pairs seq)]
        (flatten v res))
      (tset res (+ (length res) 1) seq))
  res)

(fn collect-specs [?include-disabled]
  (-> :rv-config
      load-modules
      flatten
      vim.iter
      (: :filter #(and (= (type $1) :table)
                       (or ?include-disabled
                           (not= (?. $1 :data :enabled) false))))
      (: :totable)
      flatten))

(fn src->name [src]
  (when src
    (-> src
        (: :gsub "%.git$" "")
        (: :match "[^/]+$"))))

{: collect-specs
 : src->name}
