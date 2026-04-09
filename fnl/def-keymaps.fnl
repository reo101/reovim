(local spec (require :keymaps.spec))
(local emit-vim (require :keymaps.emit-vim))
(local emit-which-key (require :keymaps.emit-which-key))
(local emit-hydra (require :keymaps.emit-hydra))

(fn def-keymaps [mode keymaps opts]
  {:fnl/docstring
   "
   Recursively define keybinds using nested tables.

   Supports:
   - Array leaves:
       [cmd desc]
       [cmd desc mode]
       [cmd desc mode opts]
   - Map leaves:
       {:cmd f :desc \"Desc\" :mode :n or [:n :v] :opts {...}}
   - Optional global mode:
       (def-keymaps keymaps opts) or (def-keymaps mode keymaps opts)
   "
   :fnl/arglist [mode keymaps opts]}
  (let [(provided-mode input-keymaps input-opts) (spec.normalize-args mode keymaps opts)
        plan (spec.compile provided-mode input-keymaps input-opts)
        debug? (or plan.debug false)]
    (when debug?
      (vim.print {:provided-mode provided-mode
                  :maps (length plan.maps)
                  :labels (length plan.labels)
                  :groups (length plan.groups)
                  :hydras (length plan.hydras)}))
    (emit-hydra.emit plan.hydras debug?)
    (emit-which-key.emit plan.groups plan.labels debug?)
    (emit-vim.emit plan.maps debug?)
    nil))

def-keymaps
