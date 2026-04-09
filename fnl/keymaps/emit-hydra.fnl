;;; Emit hydra specs when the plugin is available.

(fn hydra-factory? [mod]
  (or (= (type mod) :function)
      (and (= (type mod) :table)
           (= (type (?. (getmetatable mod) :__call)) :function))))

(fn load-hydra []
  (let [(ok mod) (pcall require :hydra)]
    (when (and ok (hydra-factory? mod))
      mod)))

(fn emit [hydras ?debug]
  (if (= (length (or hydras [])) 0)
      nil
      (let [hydra (load-hydra)]
        (if (not hydra)
            (vim.notify_once "Hydra not found, skipping hydra keymaps"
                             vim.log.levels.WARN)
            (each [_ hydra-spec (ipairs hydras)]
              (let [conf {:name hydra-spec.group
                          :hint hydra-spec.hint
                          :config hydra-spec.config
                          :mode hydra-spec.modes
                          :body hydra-spec.body
                          :heads hydra-spec.heads}]
                (when ?debug
                  (vim.print {:emitter :hydra
                              :config conf}))
                ;; Preserve the legacy `group` field for existing call sites that
                ;; might still inspect it, while also setting Hydra's `name`.
                (when (= hydra-spec.kind :only)
                  (tset conf :group hydra-spec.group))
                (hydra conf)))))))

{: emit}
