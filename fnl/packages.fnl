;; Load rv-nix and register lze handler BEFORE loading plugin specs
;; This ensures autoload proxies can find plugins via lze's on_require
(local rv-nix (require :rv-nix))
(rv-nix.setup {:non-nix-value true})
(rv-nix.register-lze-handler)

(local package-specs (require :packages.specs))
(local specs (package-specs.collect-specs))

;; Helper to extract plugin name from src URL
;; Matches vim.pack's algorithm: strip .git suffix, then take last path component
;; e.g. "https://github.com/nvim-lua/plenary.nvim" -> "plenary.nvim"
;; When running under Nix, use lze directly with :packadd
;; instead of vim.pack.add which downloads plugins
(if rv-nix.is-nix
  (let [lze (require :lze)
        ;; Get nix plugin list to filter specs
        nix-plugins (or (rv-nix.get {} :plugins :lazy) {})]
    ;; Transform specs: flatten data fields to root for lze consumption
    ;; lze needs on_require, event, after, etc. at the root level
    (each [_ spec (ipairs specs)]
      (when spec.src
        (let [name (package-specs.src->name spec.src)]
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
                       (: :map #(let [name (package-specs.src->name $1.src)]
                                  ;; Preserve root-level fields (version/rev/branch/build)
                                  ;; while still exposing data fields at the top-level for lze.
                                  (vim.tbl_extend :force
                                    {:name name}
                                    $1
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
                         spec p.spec
                         name p.name
                         build-task (?. spec :data :build)]
                     (when (and (not= p.kind :delete)
                                (= (type build-task) :function))
                       (pcall build-task p))
                     ;; Trigger NixUpdateLock for the changed plugin
                     (when (not= p.kind :delete)
                       (let [lockfile (require :nix.lockfile)]
                         (lockfile.update-all-hashes :plugins 8 false {name true}))))})
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
