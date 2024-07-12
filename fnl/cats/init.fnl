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

(fn M.lazy-setup [plugin-table nix-lazy-path lazy-specs lazy-cfg]
  ;; TODO: leave this here?
  (fn regular-lazy-download []
    (let [lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim)]
      (when (not (vim.loop.fs_stat lazypath))
        (vim.fn.system [:git
                        :clone
                        "--filter=blob:none"
                        "https://github.com/folke/lazy.nvim.git"
                        :--branch=stable
                        lazypath]))
      lazypath))
  ;; (-> vim.g
  ;;   vim.iter
  ;;   ;; (: :filter #($1:match "^nixCats"))
  ;;   (: :totable))
  (local nix-cats-path vim.g.nixCats-special-rtp-entry-nixCats)
  (var lazypath nil)
  (if (= nix-cats-path nil)
      (do
        (set lazypath (regular-lazy-download))
        (vim.opt.rtp:prepend lazypath))
      ;; else
      (let [nix-cats (require :nixCats)
            grammar-dir nix-cats.pawsible.allPlugins.ts_grammar_plugin
            my-neovim-packages (.. vim.g.nixCats-special-rtp-entry-vimPackDir
                                   :/pack/myNeovimPackages)
            nix-cats-config-dir (nix-cats.get.nixCats_store_config_location)]
        (set lazypath nix-lazy-path)
        (when (= lazypath nil)
          (set lazypath (regular-lazy-download)))
        (when (not= (type lazy-cfg) :table)
          (set-forcibly! lazy-cfg {}))
        (when (= lazy-cfg.performance nil)
          (set lazy-cfg.performance {}))
        (when (= lazy-cfg.performance.rtp nil)
          (set lazy-cfg.performance.rtp {}))
        (set lazy-cfg.performance.rtp.reset false)
        (set vim.opt.rtp
             [nix-cats-config-dir
              nix-cats-path
              grammar-dir
              (.. (vim.fn.stdpath :data) :/site)
              lazypath
              vim.env.VIMRUNTIME
              (.. (vim.fn.fnamemodify vim.v.progpath ":p:h:h") :/lib/nvim)
              (.. nix-cats-config-dir :/after)])
        (when (= lazy-cfg.dev nil)
          (set lazy-cfg.dev {}))
        (local old-path lazy-cfg.dev.path)
        (set lazy-cfg.dev.path
             (fn [plugin]
               (var path nil)
               (if (and (= (type old-path) :string)
                        (= (vim.fn.isdirectory
                             (.. old-path
                                 "/"
                                 plugin.name))
                           1))
                   (set path (.. old-path "/" plugin.name))
                   (= (type old-path) :function)
                   (do
                     (set path (old-path plugin))
                     (when (not= (type path) :string)
                       (set path nil))))
               (when (= path nil)
                 (let [start-path (.. my-neovim-packages
                                      :/start/
                                      plugin.name)
                       opt-path   (.. my-neovim-packages
                                      :/opt/
                                      plugin.name)
                       local-path (.. "~/Projects/Home/Vim/"
                                      plugin.name)]
                   (set path
                        (if (= (vim.fn.isdirectory start-path) 1)
                            start-path
                            (= (vim.fn.isdirectory opt-path) 1)
                            opt-path
                            ;; else
                            local-path))))
               path))
        (if (or (= lazy-cfg.dev.patterns nil)
                (not= (type lazy-cfg.dev.patterns) :table))
            (set lazy-cfg.dev.patterns
                 (M.get-table-names-or-list-values plugin-table))
            (do
              (var to-include nil)
              (set to-include lazy-cfg.dev.patterns)
              (vim.list_extend
                to-include
                (M.get-table-names-or-list-values plugin-table))
              (set lazy-cfg.dev.patterns to-include)))))
  (local lazy (require :lazy))
  (lazy.setup lazy-specs lazy-cfg))

M
