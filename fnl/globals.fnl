;; Reload a module and optionally its sumodules
(fn _G.R [name all-submodules]
  (let [reload (. (require :plenary.reload) :reload_module)]
    (reload name all-submodules)))

;; Safe require
(fn _G.prequire [...]
  (let [(status lib) (pcall require ...)]
    (if status
        lib
        nil)))
