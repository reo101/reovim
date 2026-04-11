;; Load rv-nix before loading plugin specs.
(local rv-nix (require :rv-nix))
(rv-nix.setup {:non-nix-value true})

(local package-specs (require :packages.specs))
(local specs (package-specs.collect-specs))

(fn spec->lze-spec [spec name ?drop-src]
  (let [copy (vim.deepcopy spec)
        lze-spec (vim.tbl_extend :force
                                 {:name name}
                                 copy
                                 (or copy.data {}))]
    (when ?drop-src
      (tset lze-spec :src nil))
    lze-spec))

;; Helper to extract plugin name from src URL
;; Matches vim.pack's algorithm: strip .git suffix, then take last path component
;; e.g. "https://github.com/nvim-lua/plenary.nvim" -> "plenary.nvim"
;; When running under Nix, use lze directly with :packadd
;; instead of vim.pack.add which downloads plugins
(if rv-nix.is-nix
  (let [lze (require :lze)
        ;; Get nix plugin list to filter specs
        nix-plugins (or (rv-nix.get {} :plugins :lazy) {})]
    ;; Only keep specs for plugins actually present in this wrapped package,
    ;; then flatten data fields to root level for lze consumption.
    (let [specs
           (-> specs
               vim.iter
               (: :map (fn [spec]
                         (if spec.src
                             (let [name (package-specs.src->name spec.src)]
                               (when (and name (. nix-plugins name))
                                 (spec->lze-spec spec name true)))
                             (vim.deepcopy spec))))
               (: :filter #$1)
               (: :totable))]
    ;; Load via lze which will use :packadd for plugins in opt/
    (lze.load specs)))
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
                                  (spec->lze-spec $1 name)))
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
