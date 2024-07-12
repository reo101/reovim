(fn config []
  (let [femaco (require :femaco)
        {:clip_val clip-val} (require :femaco.utils)
        {:edit_code_block edit-code-block} (require :femaco.edit)
        dk (require :def-keymaps)
        opt {;; should prepare a new buffer and return the winid
             ;; by default opens a floating window
             ;; provide a different callback to change this behaviour
             ;; @param opts: the return value from float_opts
             :prepare_buffer
               (fn [opts]
                 (let [buf (vim.api.nvim_create_buf false false)]
                   (vim.api.nvim_open_win buf true opts)))
             ;; should return options passed to nvim_open_win
             ;; @param code_block: data about the code-block with the keys
             ;;   * range
             ;;   * lines
             ;;   * lang
             :float_opts (fn [code-block]
                           {:relative :cursor
                            :width (clip-val 5
                                             120
                                             (- (vim.api.nvim_win_get_width 0)
                                                10))
                            :height (clip-val 5
                                              (length code-block.lines)
                                              (- (vim.api.nvim_win_get_height 0)
                                                 6))
                            :anchor :NW
                            :row 0
                            :col 0
                            :style :minimal
                            :border :rounded
                            :zindex 1})
             ;; return filetype to use for a given lang
             ;; lang can be nil
             :ft_from_lang (fn [lang]
                             lang)
             ;; what to do after opening the float
             :post_open_float (fn [winnr]
                                (set vim.wo.signcolumn :no))
             ;; create the path to a temporary file
             :create_tmp_filepath (fn [filetype]
                                    (os.tmpname))
             ;; if a newline should always be used, useful for multiline injections
             ;; which separators needs to be on separate lines such as markdown, neorg etc
             ;; @param base_filetype: The filetype which FeMaco is called from, not the
             ;; filetype of the injected language (this is the current buffer so you can
             ;; get it from vim.bo.filetyp).
             :ensure_newline (fn [base_filetype]
                               false)}]
    (femaco.setup opt)

    (dk :n
        {:l {:group :LSP
             :m [edit-code-block :FeMaco]}}
        {:prefix :<leader>})))

{1 :AckslD/nvim-FeMaco.lua
 :ft [:markdown]
 : config}
