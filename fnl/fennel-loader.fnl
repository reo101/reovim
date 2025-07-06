;;; Custom Fennel loader
;;; Finds and injects the custom Fennel fork with `#_` discard reader macro support.
;;; Used by both `.nfnl.fnl` and `bootstrap-nfnl.fnl`.

(local dev-fennel-path (.. vim.env.HOME "/Projects/Home/Fennel/Fennel"))

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

(fn purge-fennel-modules []
  "Remove all fennel modules from `package.loaded` and `package.preload`"
  (each [_ tbl (ipairs [:loaded :preload])]
    (each [k _ (pairs (. package tbl))]
      (when (or (k:match "^fennel%.")
                (k:match "^nfnl%.fennel"))
        (tset (. package tbl) k nil)))))

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
      (tset package.loaded :nfnl.fennel fennel)
      fennel)))

;; Path to typed-fennel for macro support (shared between nfnl and :Fnl)
(fn typed-fennel-macro-path []
  "Returns the macro path for typed-fennel annotations"
  (.. (vim.fn.stdpath :data) "/site/pack/core/opt/typed-fennel/fnl/?.fnl"))

;; Configure fennel with typed-fennel macro path
(fn setup-fennel-paths [fennel]
  "Setup fennel macro path to include typed-fennel"
  (let [macro-path (typed-fennel-macro-path)]
    (when (= (type fennel) :table)
      ;; Add typed-fennel to macro path if not already present
      (when (and fennel.macro_path
                 (not (: fennel.macro_path :match (vim.pesc macro-path))))
        (set fennel.macro_path (.. macro-path ";" fennel.macro_path))))))

{: dev-fennel-path
 : find-nix-fennel-path
 : has-discard-support?
 : find-custom-fennel
 : purge-fennel-modules
 : inject-custom-fennel
 : typed-fennel-macro-path
 : setup-fennel-paths}
