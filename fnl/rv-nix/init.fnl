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

;; Check if a spec is enabled (via nix-wrapper-modules settings)
(fn M.enabled? [spec-name default]
  (if M.is-nix
      (let [enabled (M.get :settings :cats spec-name)]
        (if (= enabled nil) false enabled))
      (or default false)))

;; lze handler for conditional plugin loading based on nix specs
(set M.for-spec
     {:spec_field :for-spec
      :set_lazy false
      :modify (fn [plugin]
                (let [spec plugin.for-spec]
                  (if (and (= (type spec) :table)
                           (not= spec.name nil))
                      ;; Table format: {:name :spec-name :default true}
                      (tset plugin :enabled (M.enabled? spec.name spec.default))
                      ;; Simple string format: :spec-name
                      (tset plugin :enabled (M.enabled? spec false)))
                  plugin))})

(fn M.register-lze-handler []
  (local lze (require :lze))
  (lze.register_handlers M.for-spec))

;; Load plugin via lze with spec from vim.pack
(fn M.load [p]
  ;; Merge spec.data fields into the root of the spec for lze consumption
  (local spec (or (?. p :spec :data) {}))
  (tset spec :name p.spec.name)
  (local lze (require :lze))
  (lze.load spec))

M