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
  ;; Recursively traverses directories to find all module init.lua files
  (fn scan-modules [dir-path mod-prefix results]
    (each [entry (vim.fs.dir dir-path)]
      ;; Skip hidden/template entries
      (when (not (entry:match "^__"))
        (let [entry-path (vim.fs.joinpath dir-path entry)
              entry-type (vim.uv.fs_stat entry-path)]
          (when entry-type
            (if (= entry-type.type :directory)
                ;; Check for init.lua in this subdirectory
                (let [init-path (vim.fs.joinpath entry-path :init.lua)
                      init-stat (vim.uv.fs_stat init-path)]
                  ;; If init.lua exists, this is a module
                  (when (and init-stat (= init-stat.type :file))
                    (let [full-mod-name (.. mod-prefix "." entry)]
                      (table.insert results full-mod-name)))
                  ;; Always recurse into subdirectories to find nested modules
                  (scan-modules entry-path (.. mod-prefix "." entry) results))
                ;; For .lua files at top level only (not in subdirs)
                (let [mod-name (entry:match "^(.*)%.lua$")]
                  (when (and mod-name
                             (not= mod-name :init)
                             (= dir-path (-> (vim.fn.stdpath :data)
                                            (vim.fs.joinpath :nfnl :lua path))))
                    (let [full-mod-name (.. mod-prefix "." mod-name)]
                      (table.insert results full-mod-name)))))))))
    results)

  (let [base-path (-> (vim.fn.stdpath :data)
                      (vim.fs.joinpath :nfnl :lua path))
        module-names []]
    (scan-modules base-path path module-names)
    (icollect [_ mod-name (pairs module-names)]
      ;; Extra safety: skip if mod-name is somehow nil
      (when mod-name
        (let [result (require mod-name)]
          result)))))

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

;; Ensure libraries are processed first so their dep_of registrations work
(local libraries-spec
  (require :rv-config.libraries))

(local other-specs
  (-> rv-config-mods
      vim.iter
      (: :filter #(and (not= $1.src "https://github.com/nvim-lua/plenary.nvim")
                       (not= (?. $1 :data :enabled) false)))
      (: :totable)))

(local specs
  (flatten [libraries-spec other-specs]))

;; (when rv-nix.is-nix)

(let [group (vim.api.nvim_create_augroup
              :VimPackBuilds
              {:clear false})]
  (vim.api.nvim_create_autocmd
    :User
    {: group
     :pattern :PackChanged
     :callback #(let [p $.data
                       build-task (?. p :spec :data :build)]
                   (when (and (not= p.kind :delete)
                              (= (type build-task) :function))
                     (pcall build-task p)))}))

(vim.pack.add specs {:confirm false
                     :load rv-nix.load})

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
