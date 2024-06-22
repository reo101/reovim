(import-macros
  {: rv
   : ||>
   : forieach
   : imap
   : dbg!}
  :init-macros)

;; (local lazy (require :lazy))

(local main-plugins
    [;; Fennel loader
     {1 :udayvir-singh/tangerine.nvim
      :priority 1000
      :lazy false}

     ;; Luarocks
     {1 :vhyrro/luarocks.nvim
      :priority 1000
      :opts {:rocks [:luautf8]}}

     ;; Typed fennel
     {1 :reo101/typed-fennel
      ;; 1 :dokutan/typed-fennel
      :branch :subdirectories}

     ;; Async IO
     {1 :nvim-neotest/nvim-nio
      :tag :v1.8.0
      :lazy true}])

(local opts
       {:concurrency 30
        ;; :install
        ;;   {:colorscheme :tokyonight}
        ;; :defaults {:lazy true}
        :debug false
        :profiling
          {:loader false
           :require false}
        :performance
          {:reset_packpath false
           :cache {:enabled false}
           :rtp
             {:disabled_plugins
                ["2html_plugin"
                 "getscript"
                 "getscriptPlugin"
                 "gzip"
                 "logipat"
                 "netrw"
                 "netrwPlugin"
                 "netrwSettings"
                 "netrwFileHandlers"
                 "matchit"
                 "matchparen"
                 "spec"
                 "tar"
                 "tarPlugin"
                 "rrhelper"
                 "spellfile_plugin"
                 "vimball"
                 "vimballPlugin"
                 "zip"
                 "zipPlugin"]}}})

(fn preload [path]
  (icollect [mod (-> (vim.fn.stdpath :config)
                     (vim.fs.joinpath :fnl path)
                     vim.fs.dir)]
    (let [mod (or (mod:match "^(.*)%.fnl$")
                  mod)]
       (require (.. path :. mod)))))

(local cats (require :cats))

(cats.setup {:non-nix-value true})

(var plugin-list nil)
(var nix-lazy-path nil)
(when cats.is-nix-cats
  (local nix-cats (require :nixCats))
  (local all-plugins nix-cats.pawsible.allPlugins)
  (set plugin-list
       (cats.mergePluginTables
         all-plugins.start
         all-plugins.opt))
  ;; (tset plugin-list :Comment.nvim "")
  ;; (tset plugin-list :LuaSnip "")
  (set nix-lazy-path (. all-plugins.start :lazy.nvim)))
(local lazy-options {:lockfile (.. (vim.fn.stdpath :config) :/lazy-lock.json)})

;; (vim.print
;;   {: plugin-list
;;    : nix-lazy-path
;;    :plugins [main-plugins
;;              (preload :rv-config)]
;;    : opts})

(cats.lazy-setup
  plugin-list
  nix-lazy-path
  [main-plugins
   (preload :rv-config)]
  opts)

;; (lazy.setup
;;   [main-plugins
;;    (preload :rv-config)]
;;   opts)
