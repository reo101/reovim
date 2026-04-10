;;; Side-effect-free plugin spec discovery shared by `packages.fnl` and `nix.lockfile`.

(fn scan-modules [dir-path mod-prefix results]
  "Scan one level of compiled Lua modules under `dir-path`."
  (each [entry (vim.fs.dir dir-path)]
    ;; Skip hidden/template entries.
    (when (not (entry:match "^__"))
      (let [entry-path (vim.fs.joinpath dir-path entry)
            entry-type (vim.uv.fs_stat entry-path)
            full-mod-name (.. mod-prefix "." entry)]
        (when entry-type
          (if (= entry-type.type :directory)
              (let [init-path (vim.fs.joinpath entry-path :init.lua)
                    init-stat (vim.uv.fs_stat init-path)]
                (when (and init-stat (= init-stat.type :file))
                  (table.insert results full-mod-name)))
              (let [mod-name (entry:match "^(.*)%.lua$")]
                (when mod-name
                  (table.insert results (.. mod-prefix "." mod-name)))))))))
  results)

(fn config-dir []
  ;; `debug.getinfo` returns source as `@/path/to/file.lua`, strip the `@`.
  (let [this-file (-> (debug.getinfo 1 :S) (. :source) (: :sub 2))
        this-dir (vim.fn.fnamemodify this-file ":h")]
    (vim.fn.fnamemodify this-dir ":h:h")))

(fn search-paths [path]
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
  "Require all modules under a compiled Lua module prefix."
  (local base-paths (search-paths path))
  (var module-names [])

  (each [_ base-path (ipairs base-paths)]
    (when (= 1 (vim.fn.isdirectory base-path))
      (scan-modules base-path path module-names)))

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
