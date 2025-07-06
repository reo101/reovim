(fn def-keymaps [mode keymaps opts]
  {:fnl/docstring
   "
   Recursively define keybinds using nested tables

   Supports:
   - Array leaves:
       [cmd desc]
       [cmd desc mode]          ; desc may be nil
       [cmd desc mode opts]     ; opts table merged into keymap opts
   - Map leaves:
       {:cmd f :desc \"Desc\" :mode :n or [:n :v] :opts {...}}
   - Optional global mode:
       (def-keymaps keymaps opts) or (def-keymaps mode keymaps opts)
   "
   :fnl/arglist [mode keymaps opts]}
;; cleaned diagnostics: remove entry-rec breadcrumb
  (let [;; Validators (placed first so they can be reused below)
        is-valid-cmd  (fn [cmd]  (vim.tbl_contains [:string :function] (type cmd)))
        is-valid-desc (fn [desc] (vim.tbl_contains [:string] (type desc)))
        is-valid-mode (fn [m]
                        (or (= (type m) :string)
                            (and (vim.islist m)
                                 (-> m vim.iter (: :all #(= (type $) :string))))))

        normalize-args (fn [a b c]
                         "Optional-args normalizer, returns `provided-mode`, `keymaps`, `opts`.
                          Handles both (mode, keymaps, opts) and (keymaps, opts) and (nil, keymaps, opts)."
                         (if
                           ;; (mode, keymaps, opts)
                           (is-valid-mode a)
                           (values a (or b {}) (or c {}))

                           ;; (keymaps, opts)
                           (or (= (type a) :table) (vim.islist a))
                           (values nil (or a {}) (or b {}))

                           ;; (nil, keymaps, opts) — common in recursion
                           (or (and (= a nil) (= (type b) :table))
                               (and (= a nil) (vim.islist b)))
                           (values nil (or b {}) (or c {}))

                           ;; Fallback: nothing sensible, return empties
                           :else
                           (values nil {} {})))

        (provided-mode input-keymaps input-opts) (normalize-args mode keymaps opts)

        ;; cleaned: remove post-norm and pre-init breadcrumbs

        {:prefix ?prefix
         :debug  ?debug?
         &       opts} input-opts
        prefix (or ?prefix "")
        debug? (or ?debug? false)

        ;; Pull group metadata and children
        {:hydra  hydra?
         :group  group?
         :hint   hint?
         :config config?
         :mode   group-mode
         &       keymaps} input-keymaps

        ;; Resolve global/group mode (can be string or list, or nil)
        global-mode (or group-mode provided-mode)
        ;; Utilities
        leaf-table? (fn [rhs]
                      (and (= (type rhs) :table)
                           (not (vim.islist rhs))
                           (or (not= rhs.cmd  nil)
                               (not= rhs.desc nil)
                               (not= rhs.mode nil)
                               (not= rhs.opts nil))))

        ;; General opts and helpers
        base-opts {:silent true :remap false}
        ;; Strip only our special opts; leave the rest intact for vim.keymap.set
        special-opts {"prefix" true "debug" true "recurse" true}
        strip-opts (fn [o]
                     (if (not= (type o) :table) {}
                         (collect [k v (pairs o)
                                   &into {}]
                           (if (and (= (type k) :string)
                                    (. special-opts k))
                               nil
                               (values k v)))))
        general-opts (strip-opts (vim.tbl_extend :force base-opts opts))

        ;; Hydra
        (has-hydra? hydra) (pcall require :hydra)]

    (fn dbg [title payload]
      (when debug?
        (vim.print (.. "[dk] " title))
        (vim.print payload)))

    (dbg "init"
         {:provided_mode provided-mode
          :prefix        prefix
          :group         group?
          :hydra         hydra?
          :keys          (-> keymaps pairs vim.iter (: :map #$1) (: :totable))})

    (fn ensure-modes [m]
      (if (is-valid-mode m)
          m
          (is-valid-mode global-mode)
          global-mode
          ;; else
          :n))
    (fn with-modes [m f]
      (if (vim.islist m)
          (each [_ mm (ipairs m)] (f mm))
          (f m)))

    (fn notify [title mess]
      (vim.notify mess vim.log.levels.TRACE {: title})
      (vim.print (string.format "%s: %s" title mess)))

    ;; Define canonicalizer here (recursive)
    (fn canonicalize [rhs]
      (if
        ;; 0) multi: list of leaves
        (and (vim.islist rhs)
             (> (length rhs) 0)
             (-> rhs
                 vim.iter
                 (: :all (fn [v]
                           (let [islist (vim.islist v)
                                 len    (and islist (length v))]
                             (or (and islist (<= 1 len 4))
                                 (and (= (type v) :table)
                                      (not (vim.islist v)))))))))
        {:kind :multi :leaves (->> rhs (vim.tbl_map canonicalize))}

        ;; 1) plain cmd (no desc)
        (is-valid-cmd rhs)
        {:kind :leaf :cmd rhs :final true}

        ;; 2a) [desc] (which-key label only)
        (and (vim.islist rhs)
             (= (length rhs) 1)
             (is-valid-desc (. rhs 1)))
        {:kind :leaf :desc (. rhs 1) :final true}

        ;; 2b) [cmd desc]
        (and (vim.islist rhs)
             (= (length rhs) 2)
             (is-valid-cmd (. rhs 1))
             (or (is-valid-desc (. rhs 2)) (= (. rhs 2) nil)))
        {:kind :leaf :cmd (. rhs 1) :desc (. rhs 2) :final true}

        ;; 3) [cmd desc mode]
        (and (vim.islist rhs)
             (= (length rhs) 3)
             (is-valid-cmd (. rhs 1))
             (or (is-valid-desc (. rhs 2)) (= (. rhs 2) nil))
             (is-valid-mode (. rhs 3)))
        {:kind :leaf :cmd (. rhs 1) :desc (. rhs 2) :mode (. rhs 3) :final true}

        ;; 4) [cmd desc mode opts]
        (and (vim.islist rhs)
             (= (length rhs) 4)
             (is-valid-cmd (. rhs 1))
             (or (is-valid-desc (. rhs 2)) (= (. rhs 2) nil))
             (is-valid-mode (. rhs 3))
             (= (type (. rhs 4)) :table))
        {:kind :leaf :cmd (. rhs 1) :desc (. rhs 2) :mode (. rhs 3) :opts (. rhs 4) :final true}

        ;; 5) map leaf
        (leaf-table? rhs)
        {:kind :leaf :cmd rhs.cmd :desc rhs.desc :mode rhs.mode :opts rhs.opts :final true}

        ;; 6) subtree
        (and (= (type rhs) :table) (not (vim.islist rhs)))
        {:kind :submap :tbl rhs}

        ;; else
        (error (.. "def-keymaps: invalid RHS: " (vim.inspect rhs)))))

    ;; Metadata keys to skip when walking submaps
    (local meta-keys {"group" true "name" true "hint" true "config" true "mode" true})
    (fn is-meta-key [k]
      (and (= (type k) :string)
           (. meta-keys k)))

    ;; Hydra path
    (when (and hydra? (not has-hydra?))
      (vim.notify_once "Hydra not found, continuing normally")
      (lua "return nil"))
    (var just-hydra? false)
    (case hydra?
      true (let [heads (icollect [lhs rhs (pairs keymaps)]
                        (when (not (is-meta-key lhs))
                          (let [node (canonicalize rhs)]
                            (dbg "hydra-node" {:lhs lhs :kind node.kind})
                            (case node.kind
                              :leaf  [lhs node.cmd {:desc node.desc}]
                              :multi (let [first (-> node.leaves (. 1))]
                                       (when (and first (= first.kind :leaf) first.cmd)
                                         [lhs first.cmd {:desc first.desc}]))
                              :submap nil))))
                 hydra-conf {:group  group?
                             :hint   hint?
                             :config config?
                             :mode   (ensure-modes global-mode)
                             :body   prefix
                             :heads  heads}]
             (when debug? (notify "Setting (just) hydra keymap" (vim.inspect hydra-conf)))
             (hydra hydra-conf)
             (set just-hydra? true))
      hydra-keymaps (let [heads (-> hydra-keymaps
                                    pairs
                                    vim.iter
                                    (: :filter #(not (is-meta-key $1)))
                                    (: :map (fn [lhs v]
                                              (let [node (canonicalize v)]
                                                (case node.kind
                                                  :leaf  [lhs node.cmd {:desc node.desc}]
                                                  :multi (let [first (. node.leaves 1)]
                                                           (when (and first (= first.kind :leaf) first.cmd)
                                                             [lhs first.cmd {:desc first.desc}]))
                                                  :submap nil))))
                                    (: :filter #(not= $ nil))
                                    (: :totable))
                            hydra-conf {:name   group?
                                        :hint   hint?
                                        :config config?
                                        :mode   (ensure-modes global-mode)
                                        :body   prefix
                                        :heads  heads}]
                        (when debug? (notify "Setting hydra keymap" (vim.inspect hydra-conf)))
                        (hydra hydra-conf)))

    (when (not just-hydra?)
      ;; which-key group for current prefix
      (let [(has-which-key? which-key) (pcall require :which-key)]
        (when (and has-which-key? group?)
          (when debug?
            (notify "Setting which-key group name"
                    (vim.inspect {:mode (ensure-modes global-mode) 1 prefix :group group?})))
          (which-key.add {:mode (ensure-modes global-mode) 1 prefix :group group?}))

        ;; Emit leaves and recurse
        (each [lhs rhs (pairs keymaps)]
          (let [lhs (.. prefix lhs)]
            (when (not (is-meta-key lhs))
              (let [node (canonicalize rhs)]
                (dbg "emit-node" {:lhs lhs :kind node.kind :node node})
                (case node.kind
                  :leaf
                  (if node.cmd
                      (let [modes (ensure-modes (or node.mode global-mode))
                            opts* (strip-opts (vim.tbl_extend :force general-opts (or node.opts {}) {:desc node.desc}))]
                           (with-modes modes
                             (fn [m]
                               (when debug?
                                 (notify "Setting keymap" (vim.inspect {:mode m :lhs lhs :opts opts*})))
                               (vim.keymap.set m lhs node.cmd opts*))))
                      (when (and has-which-key? node.desc)
                            (let [modes (ensure-modes (or node.mode global-mode))]
                             (with-modes modes
                               (fn [m]
                                 (when debug?
                                   (notify "Setting which-key desc"
                                           (vim.inspect {:mode m 1 lhs :desc node.desc})))
                                 (which-key.add {:mode m 1 lhs :desc node.desc}))))))

                  :multi
                  (each [_ leaf (ipairs node.leaves)]
                    (when (and leaf (= leaf.kind :leaf))
                      (if leaf.cmd
                          (let [modes (ensure-modes (or leaf.mode global-mode))
                                opts* (strip-opts (vim.tbl_extend :force general-opts (or leaf.opts {}) {:desc leaf.desc}))]
                            (with-modes modes
                              (fn [m]
                                (when debug?
                                  (notify "Setting keymap" (vim.inspect {:mode m :lhs lhs :opts opts*})))
                                (vim.keymap.set m lhs leaf.cmd opts*))))
                          (when (and has-which-key? leaf.desc)
                            (let [modes (ensure-modes (or leaf.mode global-mode))]
                              (with-modes modes
                                (fn [m]
                                  (when debug?
                                    (notify "Setting which-key desc"
                                            (vim.inspect {:mode m 1 lhs :desc leaf.desc})))
                                  (which-key.add {:mode m 1 lhs :desc leaf.desc}))))))))

                  :submap
                  (do
                    (let [group-name (or rhs.group rhs.name)]
                      (when (and has-which-key? group-name)
                        (when debug?
                          (notify "Setting which-key group name"
                                  (vim.inspect {:mode (ensure-modes global-mode) 1 lhs :group group-name})))
                        (which-key.add {:mode (ensure-modes global-mode) 1 lhs :group group-name})))
                    (dbg "recurse" {:from lhs
                                    :new_prefix lhs
                                    :keys (-> node.tbl
                                              pairs
                                              vim.iter
                                              (: :map #$1)
                                              (: :totable))})
                    (local args [global-mode
                                 node.tbl
                                 (vim.tbl_extend :force opts {:prefix lhs :debug debug? :recurse true})])
                    (dbg "recurse-args" {: args})
                    (def-keymaps (unpack args))))))))))))
                   ;; (def-keymaps global-mode
                   ;;              node.tbl
                   ;;              (vim.tbl_extend :force opts {:prefix lhs :debug debug? :recurse true}))))))))))))

def-keymaps
