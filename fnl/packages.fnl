(import-macros
  {: rv
   : ||>
   : forieach
   : imap
   : dbg!}
  :init-macros)

(local lazy (require :lazy))

(local main-plugins
    [;; Fennel loader
     {1 :udayvir-singh/tangerine.nvim
      :tag :v2.8
      :priority 1000
      :lazy false}

     ;; Typed fennel
     {1 :dokutan/typed-fennel
      :lazy true}

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
  (icollect [mod (vim.fs.dir
                   (vim.fs.joinpath
                     (vim.fn.stdpath :config)
                     :fnl
                     path))]
    (let [mod (or (mod:match "^(.*)%.fnl$")
                  mod)]
       (require (.. path :. mod)))))

(lazy.setup
  [main-plugins
   (preload :rv-config)]
  opts)
