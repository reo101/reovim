(fn config []
  (let [toggleterm (require :toggleterm)
        opt {;; size can be a number or function which is passed the current terminal
             :size (fn [term]
                     (match term.direction
                       :horizontal 15
                       :vertical (* vim.o.columns 0.4)))
             :open_mapping :<leader>tt
             ;; hide the number column in toggleterm buffers
             :hide_numbers true
             :shade_filetypes []
             ;; the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
             :shading_factor "1"
             :start_in_insert true
             ;; whether or not the open mapping applies in insert mode
             :insert_mappings false
             :persist_size false
             ;; "vertical" | "horizontal" | "tab" | "float"
             :direction :horizontal
             ;; close the terminal window when the process exits
             :close_on_exit true
             ;; change the default shell
             :shell vim.o.shell
             ;; This field is only relevant if direction is set to "float"
             :float_opts
               {;; The border key is *almost* the same as "nvim_open_win"
                ;; see :h nvim_open_win for details on borders however
                ;; the "curved" border is a custom border type
                ;; not natively supported but implemented in this plugin.
                ;; "single" | "double" | "shadow" | "curved" | ... other options supported by win open
                :border :curved
                :width (math.floor (* vim.o.columns 0.9))
                :height (math.floor (* vim.o.lines 0.8))
                :winblend 3
                :highlights
                  {:border :Normal
                   :background :Normal}}}]
    (toggleterm.setup opt)))

{1 :akinsho/toggleterm.nvim
 :keys [:<leader>tt]
 : config}
