(fn config []
  (local nvim-dap-virtual-text (require :nvim-dap-virtual-text))

  ;; virtual text deactivated (default)
  ;; (set vim.g.dap_virtual_text false)

  ;; show virtual text for current frame (recommended)
  (set vim.g.dap_virtual_text true)

  ;; request variable values for all frames (experimental)
  ;; (set vim.g.dap_virtual_text "all frames"))

  (nvim-dap-virtual-text.setup))

{1 :theHamsta/nvim-dap-virtual-text
 :dependencies [:mfussenegger/nvim-dap]
 :keys [:<leader>d]
 : config}
