;;; typed-fennel bootstrap
;;; Loads typed-fennel's macro entrypoint and preloads its runtime module.

(local fennel (require :fennel))
(local cache-key "reovim.macros.typed-fennel-defs")

(fn ensure-runtime-plugin! [plugin-name]
  "Bootstrap-time helper for the opt `typed-fennel` plugin."
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

(fn typed-fennel-path [file-name]
  (or (runtime-file "typed-fennel" file-name)
      (error (.. "macros.typed-fennel: could not find "
                 file-name
                 " for plugin typed-fennel on runtimepath or packpath")
             0)))

(fn read-file [path]
  (let [fh (assert (io.open path :r)
                   (.. "macros.typed-fennel: failed to open " path))]
    (let [src (fh:read "*a")]
      (fh:close)
      src)))

(fn eval-macro-file [path]
  (let [src (read-file path)
        (ok defs) (pcall fennel.eval src {:env "_COMPILER"
                                          :source path})]
    (if ok
        defs
        (error (.. "macros.typed-fennel: failed to load " path ": " defs) 0))))

(fn preload-fennel-module! [module-name path]
  (when (not (. package.loaded module-name))
    (tset package.preload module-name
          (fn []
            (let [(ok mod) (pcall fennel.dofile path)]
              (if ok
                  mod
                  (error (.. "macros.typed-fennel: failed to preload "
                             module-name
                             " from "
                             path
                             ": "
                             mod)
                         0)))))))

(fn typed-fennel-init-macros-path []
  (typed-fennel-path "init-macros.fnl"))

(fn typed-fennel-runtime-path []
  (typed-fennel-path "init.fnl"))

(local macro-captures
  {"fn>" :keyword.function
   "let>" :keyword
   "local>" :keyword
   "var>" :keyword})

(fn annotate-macros [defs]
  (let [annotated {}]
    (each [name value (pairs (or defs {}))]
      (let [capture (. macro-captures name)]
        (tset annotated name
              (if capture
                  {:value value
                   :capture capture}
                  value))))
    annotated))

(let [cached-defs (. package.loaded cache-key)]
  (if cached-defs
      cached-defs
      (do
        (preload-fennel-module! "typed-fennel" (typed-fennel-runtime-path))
        (let [defs {:macros (annotate-macros
                              (eval-macro-file (typed-fennel-init-macros-path)))}]
          (tset package.loaded cache-key defs)
          defs))))
