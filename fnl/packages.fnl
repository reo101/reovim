(import-macros
  {: rv
   : ||>
   : forieach
   : imap
   : dbg!}
  :init-macros)

;; (local lazy (require :lazy))

(local main-plugins
    [;; Nix helper
     {:src "https://github.com/BirdeeHub/nixCats-nvim"
      :priority 1000
      :lazy false}

     ;; Fennel loader
     {:src "https://github.com/udayvir-singh/tangerine.nvim"
      :priority 1000
      :lazy false}

     ;; Luarocks
     {:src "https://github.com/vhyrro/luarocks.nvim"
      :priority 1000
      :opts {:rocks [:luautf8]}}

     ;; Typed fennel
     {:src "https://github.com/reo101/typed-fennel"
      ;; :src "https://github.com/dokutan/typed-fennel"
      :branch :subdirectories}

     ;; Async IO
     {:src "https://github.com/nvim-neotest/nvim-nio"
      :version :v1.8.0}])

(fn preload [path]
  (icollect [mod (-> (vim.fn.stdpath :config)
                     (vim.fs.joinpath :fnl path)
                     vim.fs.dir)]
    (let [mod (or (mod:match "^(.*)%.fnl$")
                  mod)]
       (require (.. path :. mod)))))

(fn flatten [seq ?res]
  (local res (or ?res []))
  (if (vim.tbl_islist seq)
    (each [_ v (pairs seq)]
      (flatten v res))
    ;; else (atom)
    (tset res
          (+ (length res) 1)
          seq))
  res)

(fn get-plugin-key [src]
  "Extracts a unique key from a plugin source URL."
  (if (not= (type src) "string") nil
      (or (src:match "github.com/([^/]+/[^%/]+)")
          (src:match "gitlab.com/([^/]+/[^%/]+)")
          src)))

(fn sort [specs]
  "Topologically sorts a list of plugin specifications."
  (local errors [])
  (local specs-by-key {})
  (local key-list [])

  ;; 1. First pass: Index all plugins by their key.
  (each [_ spec (ipairs specs)]
    (let [key (get-plugin-key spec.src)]
      (if (and key (not (. specs-by-key key)))
          (do
            (tset specs-by-key key spec)
            (table.insert key-list key))
          (not key)
          (table.insert errors (.. "Invalid or missing `:src` in spec: " (vim.inspect spec)))
          (table.insert errors (.. "Duplicate plugin key found for `" key "`. Ensure all `:src` URLs are unique.")))))

  (when (> (length errors) 0)
    (values nil errors))

  ;; 2. Second pass: Find any missing dependencies.
  (local missing-deps-map {})
  (each [_ spec (ipairs specs)]
    (when (and spec.data spec.data.dependencies)
      (each [_ dep-key (ipairs spec.data.dependencies)]
        (when (not (. specs-by-key dep-key))
          (tset missing-deps-map dep-key true)))))

  (local missing-keys (vim.tbl_keys missing-deps-map))
  (if (> (length missing-keys) 0)
    ;; NOTE: if missing dependencies are found - create stubs for them and restart the sort
    (let [all-specs specs]
      (each [_ key (ipairs missing-keys)]
        (table.insert all-specs {:src (.. "https://github.com/" key)}))
      ;; Recursively call sort and return its result immediately.
      (sort all-specs))
    ;; NOTE: else, if all dependencies are present - proceed with the sort
    (do
      ;; 3. Third pass: Build the graph and calculate in-degrees.
      (local in-degree {})
      (local graph {})

      (each [_ key (ipairs key-list)]
        (tset in-degree key 0)
        (tset graph key []))

      (each [key spec (pairs specs-by-key)]
        (when (and spec.data spec.data.dependencies)
          (each [_ dep-key (ipairs spec.data.dependencies)]
            (table.insert (. graph dep-key) key)
            (tset in-degree key (+ (. in-degree key) 1)))))

      ;; 4. Initialize queue with plugins that have no dependencies (in-degree of 0).
      (local queue [])
      (each [_ key (ipairs key-list)]
        (when (= (. in-degree key) 0)
          (table.insert queue key)))

      ;; 5. Process the queue (Kahn's algorithm for topological sort).
      (local sorted-specs [])
      (while (> (length queue) 0)
        (let [current-key (table.remove queue 1)]
          (table.insert sorted-specs (. specs-by-key current-key))

          (each [_ dependent-key (ipairs (. graph current-key))]
            (tset in-degree dependent-key (- (. in-degree dependent-key) 1))
            (when (= (. in-degree dependent-key) 0)
              (table.insert queue dependent-key)))))

      ;; 6. Check for cycles. If not all plugins are in the sorted list, a cycle exists.
      (if (< (length sorted-specs) (length key-list))
          (let [cycle-error "Cycle detected. The following plugins are part of a dependency cycle or depend on one: "
                remaining-plugins []]
            (each [key degree (pairs in-degree)]
              (when (> degree 0)
                (table.insert remaining-plugins key)))
            (table.insert errors (.. cycle-error (table.concat remaining-plugins ", ")))
            (values nil errors))
          (values sorted-specs nil)))))

(local (specs errors)
       (-> :rv-config
         preload
         flatten
         vim.iter
         (: :filter #(not= (?. $ :data :enabled) false))
         (: :totable)
         sort))

(when errors
  (vim.print errors)
  (error "Encountered errors while sorting specs"))

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
