(fn config []
  (let [notify (require :notify)
        opt {;; Animation style (see below for details)
             :stages :fade_in_slide_out
             ;; Default timeout for notifications
             :timeout 3000
             ;; For stages that change opacity this is treated as the highlight behind the window
             :background_colour :#000000
             ;; Icons for the different levels
             :icons
               {:ERROR ""
                :WARN  ""
                :INFO  ""
                :DEBUG ""
                :TRACE "✎"}}]
    (notify.setup opt)

    (set vim.notify notify)))

{1 :rcarriga/nvim-notify
 : config}
