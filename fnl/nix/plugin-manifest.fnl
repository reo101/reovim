;;; Nix-facing active plugin inventory derived from runtime specs.

(fn export-path []
  (vim.fs.joinpath (vim.fn.stdpath :config)
                   :nix
                   :generated
                   :plugins.json))

(fn plugin-names []
  (local package-specs (require :packages.specs))
  (local seen {:lze true :typed-fennel true})
  (each [_ spec (ipairs (package-specs.collect-specs))]
    (when spec.src
      (let [name (package-specs.src->name spec.src)]
        (when name
          (tset seen name true)))))
  (local names [])
  (each [name _ (pairs seen)]
    (table.insert names name))
  (table.sort names)
  names)

(fn sync! []
  (let [output-path (export-path)
        encoded (vim.json.encode {:plugins (plugin-names)}
                                 {:indent "  " :sort_keys true})]
    (vim.fn.mkdir (vim.fn.fnamemodify output-path ":h") :p)
    (vim.fn.writefile (vim.split encoded "\n") output-path)
    output-path))

{:export-path export-path
 :plugin-names plugin-names
 :sync! sync!}
