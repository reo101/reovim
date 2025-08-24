(local M {})

(set M.is-nix-cats (not= vim.g.nixCats-special-rtp-entry-nixCats nil))

(fn M.setup [v]
  (when (not M.is-nix-cats)
    (let [nix-cats-default
           (if (and (= (type v) :table)
                    (not= v.non-nix-value nil))
               v.non-nix-value
               ;; else
               true)]
      (tset _G :nix-cats #nix-cats-default))))

(fn M.merge-plugin-tables [table1 table2]
  (vim.tbl_extend :keep table1 table2))

(fn M.enable-for-category [v default]
  (if (or M.is-nix-cats
          (= default nil))
      (if (_G.nix-cats v) true false)
      default))

(fn M.lazy-add [v o]
  (if M.is-nix-cats o v))

(fn M.get-table-names-or-list-values [plugin-table]
  (if (-> plugin-table (. 1) type (= :string))
      plugin-table
      (-> plugin-table pairs vim.iter (: :map #$1) (: :totable))))

(set M.for-cat
     {:spec_field "for-cat"
      :set_lazy false
      :modify (fn [plugin]
                (if (and (= (type plugin.for-cat) "table")
                         (not= plugin.for-cat.cat nil))
                    (if (not= (. vim.g "nixCats-special-rtp-entry-nixCats") nil)
                        (tset plugin :enabled (or (_G.nix-cats plugin.for-cat.cat) false))
                        (tset plugin :enabled plugin.for-cat.default))
                    (tset plugin :enabled (or (_G.nix-cats plugin.for-cat) false)))
                plugin)})

(fn M.register-lze-handler []
  (local lze (require :lze))
  (lze.register_handlers M.for-cat))

(fn M.load [p]
  (local spec (or (?. p :spec :data) {}))
  (tset spec :name p.spec.name)

  #_
  (when (not spec.opt)
    (vim.cmd.packadd spec.name))

  #_
  (let [path (?. package.loaded :nixCats :pawsible :allPlugins :opt :name)]
    (when path
      (vim.cmd.packadd path)))

  (local lze (require :lze))
  (lze.load spec))

M
