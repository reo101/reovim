;;; nfnl bootstrap
;;; Loads custom Fennel, sets up `rtp`, defines `:Fnl`

;; Get the actual config directory from this file's location
;; (works for both Nix store paths and stdpath)
(local this-file (-> (debug.getinfo 1 :S) (. :source) (: :sub 2)))
(local this-dir (vim.fn.fnamemodify this-file ":h"))
;; Go up one level from fnl/ to get config root
(local nvim-config (vim.fn.fnamemodify this-dir ":h"))

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
  "Add nfnl output dir and config lua dir to `rtp` and `package.path`"
  (let [nfnl-lua-dir (.. nfnl-output-dir "/lua")
        config-lua-dir (.. nvim-config "/lua")]
    ;; Add nfnl output to rtp
    (when (not (vim.tbl_contains (vim.opt.runtimepath:get) nfnl-output-dir))
      (vim.opt.runtimepath:append nfnl-output-dir))

    ;; Add config lua dir to rtp (contains compiled files in Nix build)
    (when (not (vim.tbl_contains (vim.opt.runtimepath:get) config-lua-dir))
      (vim.opt.runtimepath:append config-lua-dir))

    ;; Add both to package.path (config first for priority in Nix builds)
    (local config-path-pattern (.. config-lua-dir "/?.lua;" config-lua-dir "/?/init.lua;"))
    (local nfnl-path-pattern (.. nfnl-lua-dir "/?.lua;" nfnl-lua-dir "/?/init.lua;"))

    ;; Remove existing patterns to avoid duplicates
    (set package.path (: package.path :gsub (vim.pesc config-path-pattern) ""))
    (set package.path (: package.path :gsub (vim.pesc nfnl-path-pattern) ""))

    ;; Add config paths first (for Nix), then nfnl paths
    (set package.path (.. config-path-pattern nfnl-path-pattern package.path))))

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

(fn plugin-available? [name]
  "Check if plugin is available via :packadd (from any packdir)"
  (let [(ok _) (pcall vim.cmd.packadd {:args [name]})]
    ok))

(fn bootstrap-nfnl []
  "Bootstrap nfnl plugin via `vim.pack` or :packadd if already available"
  (trust-nfnl-config)
  ;; Try :packadd first (works with Nix-installed plugins)
  (if (plugin-available? :nfnl)
      (do
        (let [nfnl-path (.. nvim-data "/site/pack/core/opt/nfnl")
              nfnl-lua-path (.. nfnl-path "/lua/?.lua")]
          (when (= 1 (vim.fn.isdirectory nfnl-path))
            (when (not (: package.path :match (vim.pesc nfnl-lua-path)))
              (set package.path (.. nfnl-lua-path ";" package.path))))))
      ;; Fall back to vim.pack.add if not available
      (do
        (vim.pack.add [{:src "https://github.com/Olical/nfnl"}] {:confirm false})
        (let [nfnl-path (.. nvim-data "/site/pack/core/opt/nfnl")
              nfnl-lua-path (.. nfnl-path "/lua/?.lua")]
          (when (not (: package.path :match (vim.pesc nfnl-lua-path)))
            (set package.path (.. nfnl-lua-path ";" package.path)))))))

;;; Bootstrap plugins

(fn bootstrap-plugins []
  "Bootstrap essential plugins via :packadd or `vim.pack`"
  (fn ensure-plugin [name src version]
    ;; Try :packadd first - works with Nix-installed plugins in any packdir
    (let [(ok _) (pcall vim.cmd.packadd {:args [name]})]
      (when (not ok)
        ;; Fall back to vim.pack.add if plugin not available
        (vim.pack.add [{: src : version}] {:confirm false}))))

  (ensure-plugin :lze "https://github.com/BirdeeHub/lze" :v0.12.0)
  (ensure-plugin :typed-fennel "https://github.com/reo101/typed-fennel" :subdirectories))

;;; Nix detection

;; Check if we're running under Nix (nix-wrapper-modules sets nix_info_plugin_name)
(local nix-runtime? (not= vim.g.nix_info_plugin_name nil))

;;; Main

(setup-paths)
(create-fnl-command)
(create-nfnl-compile-command)
(bootstrap-nfnl)
(bootstrap-plugins)
;; Skip initial compilation at Nix runtime - bootstrap files are pre-compiled in the store
(when (and (needs-initial-compilation?) (not nix-runtime?))
  (compile-all-fennel)
  (setup-paths))
(setup-fnl-autocommand)
