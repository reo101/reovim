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
  (icollect [mod (-> (vim.fn.stdpath :data)
                     (vim.fs.joinpath :nfnl :lua path)
                     vim.fs.dir)]
    (let [mod (or (mod:match "^(.*)%.lua$")
                  mod)]
      ;; Skip template files/directories and init.lua
      (when (and (not (mod:match "^__"))
                 (not= mod :init))
        (require (.. path :. mod))))))

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

(local specs
       (-> :rv-config
         preload
         flatten
         vim.iter
         (: :filter #(not= (?. $ :data :enabled) false))
         (: :totable)))

;; (vim.print (-> specs
;;                vim.iter
;;                (: :map #$.src)
;;                (: :totable)))

(local cats (require :cats))

(cats.setup {:non-nix-value true})

;; (when cats.is-nix-cats)

(let [group (vim.api.nvim_create_augroup
              :VimPackBuilds
              {:clear false})]
  (vim.api.nvim_create_autocmd
    :PackChanged
    {: group
     :pattern :*
     :callback #(let [p $.data
                      build-task (?. p :spec :data :build)]
                  (when (and (not= p.kind :delete)
                             (= (type build-task) :function))
                    (pcall build-task p)))}))
  ;; (local nix-cats (require :nixCats))
  ;; (local all-plugins nix-cats.pawsible.allPlugins)
  ;; (set plugin-list
  ;;      (cats.mergePluginTables
  ;;        all-plugins.start
  ;;        all-plugins.opt)))

;; TODO: return `VeryLazy`, here called `DeferredUIEnter`

(cats.register-lze-handler)

(vim.pack.add specs {:confirm false
                     :load cats.load})

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
