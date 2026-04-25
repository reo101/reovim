;;; Sync helpers for Nix-facing exports derived from the tree-sitter registry.

(fn export-path []
  (vim.fs.joinpath (vim.fn.stdpath :config)
                   :nix
                   :generated
                   :treesitter-registry.json))

(fn sync! []
  (let [registry (require :rv-config.treesitter.registry)
        output-path (export-path)
        encoded (vim.json.encode (registry.nix-export)
                                 {:indent "  "
                                  :sort_keys true})]
    (vim.fn.mkdir (vim.fn.fnamemodify output-path ":h") :p)
    (vim.fn.writefile (vim.split encoded "\n") output-path)
    output-path))

{:export-path export-path
 :sync! sync!}
