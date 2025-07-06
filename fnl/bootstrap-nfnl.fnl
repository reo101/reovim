;;; nfnl bootstrap
;;; Loads custom Fennel, sets up `rtp`, defines `:Fnl`

(local nvim-config (vim.fn.stdpath :config))
(local nvim-data (vim.fn.stdpath :data))
(local nfnl-output-dir (.. nvim-data "/nfnl"))

;;; Custom Fennel

(local {: inject-custom-fennel
        : typed-fennel-macro-path
        : setup-fennel-paths}
  (require :fennel-loader))
(inject-custom-fennel)

;; Setup typed-fennel macro path for :Fnl command
(setup-fennel-paths (require :fennel))

;;; Paths

(fn setup-paths []
  "Add nfnl output dir to `rtp` and `package.path`"
  (let [nfnl-lua-dir (.. nfnl-output-dir "/lua")]
    (when (not (vim.tbl_contains (vim.opt.runtimepath:get) nfnl-output-dir))
      (vim.opt.runtimepath:append nfnl-output-dir))

    (local lua-path-pattern (.. nfnl-lua-dir "/?.lua;" nfnl-lua-dir "/?/init.lua;"))
    (set package.path (.. lua-path-pattern
                          (: package.path :gsub (vim.pesc lua-path-pattern) "")))))

;;; Compilation

(fn needs-initial-compilation? []
  "Check if nfnl `lua/` output dir exists"
  (let [nfnl-lua-dir (.. nfnl-output-dir "/lua")]
    (not= 1 (vim.fn.isdirectory nfnl-lua-dir))))

(fn compile-all-fennel []
  "Compile all Fennel files via `nfnl.api`"
  (local (ok nfnl-api) (pcall require :nfnl.api))
  (when ok
    (nfnl-api.compile-all-files nvim-config)))

(fn setup-fnl-autocommand []
  "Recompile `.fnl` files on save"
  (vim.api.nvim_create_augroup :nfnl_compile {:clear true})
  (vim.api.nvim_create_autocmd
    :BufWritePost
    {:group :nfnl_compile
     :pattern "*.fnl"
     :callback (fn [ev]
                  (local path (vim.api.nvim_buf_get_name ev.buf))
                  (local dir (vim.fn.fnamemodify path ":h"))

                  (local (ok nfnl-api) (pcall require :nfnl.api))
                  (when (not ok)
                    (vim.notify (.. "nfnl: Failed to load nfnl.api: " (tostring nfnl-api))
                                vim.log.levels.WARN)
                    (lua "return nil"))

                  (local (ok result) (pcall nfnl-api.compile-file {: path : dir}))
                  (when (not ok)
                    (vim.notify (.. "nfnl: Compilation error: " (tostring result))
                                vim.log.levels.ERROR)
                    (lua "return nil"))

                  nil)}))

;;; `:Fnl` command

(fn create-fnl-command []
  "Create `:Fnl` user command for evaluating Fennel"
  (let [fennel (require :fennel)]
    (vim.api.nvim_create_user_command
      :Fnl
      (fn [opts]
        (let [code opts.args
              (ok result) (pcall fennel.eval code {:env :_COMPILER})]
          (if ok
              (vim.print (fennel.view result))
              (vim.notify (tostring result)
                          vim.log.levels.ERROR))))
      {:nargs "+"
       :desc "Evaluate Fennel code using custom Fennel fork"})))

(fn create-nfnl-compile-command []
  "Create `:NfnlCompileAll` user command to compile all Fennel files"
  (vim.api.nvim_create_user_command
    :NfnlCompileAll
    (fn []
      (compile-all-fennel)
      (vim.notify "nfnl: Compiled all Fennel files" vim.log.levels.INFO))
    {:desc "Compile all Fennel files via nfnl"}))

;;; Trust `.nfnl.fnl`

(fn trust-nfnl-config []
  "Pre-trust `.nfnl.fnl` via `vim.secure.trust`"
  (let [nfnl-config-path (.. nvim-config "/.nfnl.fnl")]
    (when (= 1 (vim.fn.filereadable nfnl-config-path))
      (let [bufnr (vim.fn.bufadd nfnl-config-path)]
        (tset (. vim.bo bufnr) :swapfile false)
        (vim.fn.bufload bufnr)
        (pcall vim.secure.trust {: bufnr :action :allow})))))

;;; Bootstrap nfnl

(fn bootstrap-nfnl []
  "Bootstrap nfnl plugin via `vim.pack`"
  (trust-nfnl-config)
  (let [nfnl-path (.. nvim-data "/site/pack/core/opt/nfnl")
        nfnl-lua-path (.. nfnl-path "/lua/?.lua")]
    (if (= 1 (vim.fn.isdirectory nfnl-path))
        (vim.cmd.packadd {:args [:nfnl]})
        (vim.pack.add [{:src "https://github.com/Olical/nfnl"}] {:confirm false}))
    (when (not (: package.path :match (vim.pesc nfnl-lua-path)))
      (set package.path (.. nfnl-lua-path ";" package.path)))))

;;; Bootstrap plugins

(fn bootstrap-plugins []
  "Bootstrap essential plugins via `vim.pack`"
  (fn ensure-plugin [name src version]
    (let [plugin-path (.. nvim-data "/site/pack/core/opt/" name)]
      (if (= 1 (vim.fn.isdirectory plugin-path))
          (vim.cmd.packadd {:args [name]})
          (vim.pack.add [{: src : version}] {:confirm false}))))

  (ensure-plugin :lze "https://github.com/BirdeeHub/lze" :v0.12.0)
  (ensure-plugin :typed-fennel "https://github.com/reo101/typed-fennel" :subdirectories))

;;; Main

(setup-paths)
(create-fnl-command)
(create-nfnl-compile-command)
(bootstrap-nfnl)
(bootstrap-plugins)
(when (needs-initial-compilation?)
  (compile-all-fennel)
  (setup-paths))
(setup-fnl-autocommand)
