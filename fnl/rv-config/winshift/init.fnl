(fn config []
  (let [winshift (require :winshift)
        winshift-lib (require :winshift.lib)
        dk (require :def-keymaps)
        opt {:window_picker
               #(winshift-lib.pick_window
                  {;; Highlight the window being moved
                   :highlight_moving_win true
                   ;; The highlight group used for the moving window
                   :focused_hl_group :Visual
                   :moving_win_options
                     ;; These are local options applied to the moving window while it's
                     ;; being moved. They are unset when you leave Win-Move mode.
                     {:wrap false
                      :cursorline false
                      :cursorcolumn false
                      :colorcolumn ""}
                   ;; The window picker is used to select a window while swapping windows with}
                   ;;  ':WinShift swap'.
                   ;;  A string of chars used as identifiers by the window picker.
                   :picker_chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                   :filter_rules
                     {;; This table allows you to indicate to the window picker that a window
                      ;; should be ignored if its buffer matches any of the following criteria.
                      :cur_win true
                      :floats true
                      ;; List of ignored file types
                      :filetype
                        [:NvimTree]
                      ;; List of ignored buftypes
                      :buftype
                        [:terminal
                         :quickfix]
                      ;; List of regex patterns matching ignored buffer names
                      :bufname
                        []}})}]
    (winshift.setup opt)

    (dk [:n]
        {:W [winshift.cmd_winshift :WinShift]}
        {:prefix :<leader>})))

{1 :sindrets/winshift.nvim
 :keys [{1 :<leader>W :desc :WinShift}]
 : config}
