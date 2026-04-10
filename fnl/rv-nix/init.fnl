;; Nix info module - provides compatibility between nix and non-nix environments
;; Works with nix-wrapper-modules (sets vim.g.nix_info_plugin_name)
(local M {})

;; Check if running under nix (nix-wrapper-modules sets this global)
;; NOTE: nix-wrapper-modules uses snake_case: nix_info_plugin_name
(set M.is-nix (not= vim.g.nix_info_plugin_name nil))

;; DEBUG
(when (= "1" vim.env.REOVIM_NIX_BUILD)
  (vim.notify (.. "DEBUG rv-nix: nix_info_plugin_name=" (tostring vim.g.nix_info_plugin_name)
                  " is-nix=" (tostring M.is-nix))
              vim.log.levels.INFO))

;; Get nix info function if available
(fn M.get [...]
  (when M.is-nix
    (let [(ok info-fn) (pcall require vim.g.nix_info_plugin_name)]
      (if ok
          (let [(ok2 result) (pcall info-fn ...)]
            (if ok2
                result
                (do
                  (when (= "1" vim.env.REOVIM_NIX_BUILD)
                    (vim.notify (.. "DEBUG rv-nix.get: error calling info function: " (tostring result))
                                vim.log.levels.WARN))
                  nil)))
          (do
            (when (= "1" vim.env.REOVIM_NIX_BUILD)
              (vim.notify (.. "DEBUG rv-nix.get: failed to require " vim.g.nix_info_plugin_name ": " (tostring info-fn))
                          vim.log.levels.WARN))
            nil)))))

;; Setup default values when not running under nix
(fn M.setup [v]
  (when (not M.is-nix)
    (let [default-value
           (if (and (= (type v) :table)
                    (not= v.non-nix-value nil))
               v.non-nix-value
               ;; else
               true)]
      ;; Set a simple global function that returns the default
      (tset _G :nix-config #default-value))))

M
