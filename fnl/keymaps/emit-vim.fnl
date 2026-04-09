;;; Emit canonical keymap specs through `vim.keymap.set`.

(fn with-modes [m f]
  (if (vim.islist m)
      (each [_ mm (ipairs m)]
        (f mm))
      (f m)))

(fn emit [maps ?debug]
  (each [_ map-spec (ipairs (or maps []))]
    (with-modes map-spec.modes
      (fn [mode]
        (when ?debug
          (vim.print {:emitter :vim
                      :mode mode
                      :lhs map-spec.lhs
                      :opts map-spec.opts}))
        (vim.keymap.set mode map-spec.lhs map-spec.cmd map-spec.opts)))))

{:emit emit}
