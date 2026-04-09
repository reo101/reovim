;;; Compile nested keymap DSL tables into a flat emission plan.

(fn valid-cmd? [cmd]
  (vim.tbl_contains [:string :function] (type cmd)))

(fn valid-desc? [desc]
  (= (type desc) :string))

(fn valid-mode? [m]
  (or (= (type m) :string)
      (and (vim.islist m)
           (-> m vim.iter (: :all #(= (type $) :string))))))

(fn normalize-args [a b c]
  "Optional-args normalizer, returns `provided-mode`, `keymaps`, `opts`.
   Handles both `(mode, keymaps, opts)` and `(keymaps, opts)`."
  (if (valid-mode? a)
      (values a (or b {}) (or c {}))
      (or (= (type a) :table) (vim.islist a))
      (values nil (or a {}) (or b {}))
      (or (and (= a nil) (= (type b) :table))
          (and (= a nil) (vim.islist b)))
      (values nil (or b {}) (or c {}))
      :else
      (values nil {} {})))

(fn leaf-table? [rhs]
  (and (= (type rhs) :table)
       (not (vim.islist rhs))
       (or (not= rhs.cmd nil)
           (not= rhs.desc nil)
           (not= rhs.mode nil)
           (not= rhs.opts nil))))

(local special-opts {"prefix" true "debug" true "recurse" true})
(fn strip-opts [o]
  (if (not= (type o) :table)
      {}
      (collect [k v (pairs o)
                &into {}]
        (if (and (= (type k) :string)
                 (. special-opts k))
            nil
            (values k v)))))

(local meta-keys
  {"config" true
   "group" true
   "hint" true
   "hydra" true
   "mode" true
   "name" true})

(fn meta-key? [k]
  (and (= (type k) :string)
       (. meta-keys k)))

(fn ensure-modes [global-mode m]
  (if (valid-mode? m)
      m
      (valid-mode? global-mode)
      global-mode
      :else
      :n))

(fn canonicalize [rhs]
  (if
    ;; multi: list of leaves
    (and (vim.islist rhs)
         (> (length rhs) 0)
         (-> rhs
             vim.iter
             (: :all
                (fn [v]
                  (let [islist (vim.islist v)
                        len (and islist (length v))]
                    (or (and islist (<= 1 len 4))
                        (and (= (type v) :table)
                             (not (vim.islist v)))))))))
    {:kind :multi
     :leaves (->> rhs (vim.tbl_map canonicalize))}

    ;; plain cmd (no desc)
    (valid-cmd? rhs)
    {:kind :leaf :cmd rhs :final true}

    ;; [desc]
    (and (vim.islist rhs)
         (= (length rhs) 1)
         (valid-desc? (. rhs 1)))
    {:kind :leaf :desc (. rhs 1) :final true}

    ;; [cmd desc]
    (and (vim.islist rhs)
         (= (length rhs) 2)
         (valid-cmd? (. rhs 1))
         (or (valid-desc? (. rhs 2)) (= (. rhs 2) nil)))
    {:kind :leaf :cmd (. rhs 1) :desc (. rhs 2) :final true}

    ;; [cmd desc mode]
    (and (vim.islist rhs)
         (= (length rhs) 3)
         (valid-cmd? (. rhs 1))
         (or (valid-desc? (. rhs 2)) (= (. rhs 2) nil))
         (valid-mode? (. rhs 3)))
    {:kind :leaf :cmd (. rhs 1) :desc (. rhs 2) :mode (. rhs 3) :final true}

    ;; [cmd desc mode opts]
    (and (vim.islist rhs)
         (= (length rhs) 4)
         (valid-cmd? (. rhs 1))
         (or (valid-desc? (. rhs 2)) (= (. rhs 2) nil))
         (valid-mode? (. rhs 3))
         (= (type (. rhs 4)) :table))
    {:kind :leaf
     :cmd (. rhs 1)
     :desc (. rhs 2)
     :mode (. rhs 3)
     :opts (. rhs 4)
     :final true}

    ;; map leaf
    (leaf-table? rhs)
    {:kind :leaf
     :cmd rhs.cmd
     :desc rhs.desc
     :mode rhs.mode
     :opts rhs.opts
     :final true}

    ;; subtree
    (and (= (type rhs) :table) (not (vim.islist rhs)))
    {:kind :submap :tbl rhs}

    :else
    (error (.. "def-keymaps: invalid RHS: " (vim.inspect rhs)))))

(fn hydra-head [lhs node]
  (case node.kind
    :leaf
    (when node.cmd
      [lhs node.cmd {:desc node.desc}])

    :multi
    (let [first (. node.leaves 1)]
      (when (and first (= first.kind :leaf) first.cmd)
        [lhs first.cmd {:desc first.desc}]))

    :submap
    nil))

(fn push-leaf! [acc lhs leaf global-mode general-opts]
  (let [modes (ensure-modes global-mode leaf.mode)]
    (if leaf.cmd
        (table.insert acc.maps
                      {:lhs lhs
                       :cmd leaf.cmd
                       :modes modes
                       :opts (strip-opts
                               (vim.tbl_extend :force
                                               general-opts
                                               (or leaf.opts {})
                                               {:desc leaf.desc}))})
        (when leaf.desc
          (table.insert acc.labels
                        {:lhs lhs
                         :desc leaf.desc
                         :modes modes})))))

(fn compile-subtree [acc provided-mode input-keymaps input-opts]
  (let [{:prefix ?prefix
         :debug ?debug?
         & opts} (or input-opts {})
        prefix (or ?prefix "")
        debug? (or ?debug? false)
        {:hydra hydra?
         :group group?
         :hint hint?
         :config config?
         :mode group-mode
         & keymaps} input-keymaps
        global-mode (or group-mode provided-mode)
        general-opts (strip-opts
                       (vim.tbl_extend :force
                                       {:silent true :remap false}
                                       opts))
        only-hydra? (= hydra? true)]
    (tset acc :debug debug?)

    (when group?
      (table.insert acc.groups
                    {:lhs prefix
                     :group group?
                     :modes (ensure-modes global-mode group-mode)}))

    (when hydra?
      (let [hydra-keymaps (if only-hydra? keymaps hydra?)
            heads []]
        (each [lhs rhs (pairs hydra-keymaps)]
          (when (not (meta-key? lhs))
            (let [head (hydra-head lhs (canonicalize rhs))]
              (when head
                (table.insert heads head)))))
        (when (> (length heads) 0)
          (table.insert acc.hydras
                        {:kind (if only-hydra? :only :sidecar)
                         :group group?
                         :hint hint?
                         :config config?
                         :modes (ensure-modes global-mode group-mode)
                         :body prefix
                         :heads heads}))))

    (when (not only-hydra?)
      (each [raw-lhs rhs (pairs keymaps)]
        (when (not (meta-key? raw-lhs))
          (let [lhs (.. prefix raw-lhs)
                node (canonicalize rhs)]
            (case node.kind
              :leaf
              (push-leaf! acc lhs node global-mode general-opts)

              :multi
              (each [_ leaf (ipairs node.leaves)]
                (when (and leaf (= leaf.kind :leaf))
                  (push-leaf! acc lhs leaf global-mode general-opts)))

              :submap
              (do
                (let [group-name (or rhs.group rhs.name)
                      submap-mode (or rhs.mode global-mode)]
                  (when group-name
                    (table.insert acc.groups
                                  {:lhs lhs
                                   :group group-name
                                   :modes (ensure-modes global-mode submap-mode)})))
                (compile-subtree
                  acc
                  global-mode
                  node.tbl
                  (vim.tbl_extend :force
                                  opts
                                  {:prefix lhs
                                   :debug debug?
                                   :recurse true}))))))))
    acc))

(fn compile [provided-mode input-keymaps input-opts]
  (compile-subtree {:maps [] :labels [] :groups [] :hydras [] :debug false}
                   provided-mode
                   input-keymaps
                   input-opts))

{:normalize-args normalize-args
 :strip-opts strip-opts
 :meta-key? meta-key?
 :canonicalize canonicalize
 :compile compile}
