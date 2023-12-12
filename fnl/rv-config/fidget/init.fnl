(fn config []
  (let [fidget (require :fidget)
        opt {
             ;; Options related to LSP progress subsystem
             :progress
               {;; How and when to poll for progress messages
                :poll_rate 0
                ;; Suppress new messages while in insert mode
                :suppress_on_insert false
                ;; Ignore new tasks that are already complete
                :ignore_done_already false
                ;; Ignore new tasks that don't contain a message
                :ignore_empty_message false
                ;; Clear notification group when LSP server detaches
                :clear_on_detach (fn [client-id]
                                   (local client
                                          (vim.lsp.get_client_by_id client-id))
                                   (or (and client client.name) nil))
                ;; How to get a progress message's notification group key
                :notification_group (fn [msg] msg.lsp_client.name)
                ;; List of LSP servers to ignore
                :ignore {}
                ;; Options related to how LSP progress messages are displayed as notifications
                :display {;; How many LSP messages to show at once
                          :render_limit 16
                          ;; How long a message should persist after completion
                          :done_ttl 3
                          ;; Icon shown when all LSP progress tasks are complete
                          :done_icon "✔"
                          ;; Highlight group for completed LSP tasks
                          :done_style :Constant
                          ;; How long a message should persist when in progress
                          :progress_ttl math.huge
                          ;; Icon shown when LSP progress tasks are in progress
                          :progress_icon {:pattern :dots :period 1}
                          ;; Highlight group for in-progress LSP tasks
                          :progress_style :WarningMsg
                          ;; Highlight group for group name (LSP server name)
                          :group_style :Title
                          ;; Highlight group for group icons
                          :icon_style :Question
                          ;; Ordering priority for LSP notification group
                          :priority 30
                          ;; How to format a progress message
                          :format_message (. (require :fidget.progress.display)
                                             :default_format_message)
                          ;; How to format a progress annotation
                          :format_annote (fn [msg]
                                           msg.title)
                          ;; How to format a progress notification group's name
                          :format_group_name (fn [group]
                                               (tostring group))
                          ;; Override options from the default notification config
                          :overrides {:rust_analyzer {:name :rust-analyzer}}}
                ;; Options related to Neovim's built-in LSP client
                :lsp
                  {;; Configure the nvim's LSP progress ring buffer size
                   :progress_ringbuf_size 0}}
             ;; Options related to notification subsystem
             :notification
               {;; How frequently to update and render notifications
                :poll_rate 10
                ;; Minimum notifications level
                :filter vim.log.levels.INFO
                ;; Automatically override vim.notify() with Fidget
                :override_vim_notify false
                ;; How to configure notification groups when instantiated
                :configs
                  {:default (. (require :fidget.notification)
                               :default_config)}
                ;; Options related to how notifications are rendered as text
                :view
                  {;; Display notification items from bottom to top
                   :stack_upwards true
                   ;; Separator between group name and icon
                   :icon_separator " "
                   ;; Separator between notification groups
                   :group_separator "---"
                   ;; Highlight group used for group separator
                   :group_separator_hl :Comment}
                ;; Options related to the notification window and buffer
                :window
                  {;; Base highlight group in the notification window
                   :normal_hl :Comment
                   ;; Background color opacity in the notification window
                   :winblend 100
                   ;; Border around the notification window
                   :border :none
                   ;; Stacking priority of the notification window
                   :zindex 45
                   ;; Maximum width of the notification window
                   :max_width 0
                   ;; Maximum height of the notification window
                   :max_height 0
                   ;; Padding from right edge of window boundary
                   :x_padding 1
                   ;; Padding from bottom edge of window boundary
                   :y_padding 0
                   ;; How to align the notification window
                   :align :bottom
                   ;; What the notification window position is relative to
                   :relative :editor}}
             ;; ;; Options related to integrating with other plugins
             ;; :integration
             ;;   {;; Integrate with nvim-tree/nvim-tree.lua (if installed)
             ;;    :nvim-tree {:enable true}}
             ;; Options related to logging
             :logger
               {;; Minimum logging level
                :level vim.log.levels.WARN
                ;; Limit the number of decimals displayed for floats
                :float_precision 0.01
                ;; Where Fidget writes its logs to
                :path (string.format
                        "%s/fidget.nvim.log"
                        (vim.fn.stdpath :cache))}}]

    (fidget.setup opt)))

{: config}
