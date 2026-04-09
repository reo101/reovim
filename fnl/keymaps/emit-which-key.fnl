;;; Emit group and label metadata through `which-key`.

(fn with-modes [m f]
  (if (vim.islist m)
      (each [_ mm (ipairs m)]
        (f mm))
      (f m)))

(fn emit-entry! [which-key mode lhs key value ?debug]
  (when ?debug
    (vim.print {:emitter :which-key
                :mode mode
                :lhs lhs
                key value}))
  (which-key.add {:mode mode 1 lhs key value}))

(fn emit [groups labels ?debug]
  (let [(has-which-key? which-key) (pcall require :which-key)]
    (when has-which-key?
      (each [_ group-spec (ipairs (or groups []))]
        (with-modes group-spec.modes
          (fn [mode]
            (emit-entry! which-key mode group-spec.lhs :group group-spec.group ?debug))))
      (each [_ label-spec (ipairs (or labels []))]
        (with-modes label-spec.modes
          (fn [mode]
            (emit-entry! which-key mode label-spec.lhs :desc label-spec.desc ?debug)))))))

{:emit emit}
