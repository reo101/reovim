(fn config []
  (let [dapui (require :dapui)
        dk (require :def-keymaps)
        ;; position may be `:left` | `:right` | `:top` | `:bottom`
        opt {:icons {:expanded "▾"
                     :collapsed "▸"}
             :mappings {:expand [:<CR> :<2-LeftMouse>]
                        :open :o
                        :remove :d
                        :edit :e
                        :repl :r}
             :layouts [{:elements [:scopes
                                   :breakpoints
                                   :stacks
                                   :watches]
                        :size 40
                        :position :left}
                       {:elements [:repl
                                   :console]
                        :size 10
                        :position :bottom}]
             :sidebar
               {:elements
                  [;; Provided as ID strings or tables with `:id` and `:size` keys
                   ;; `:size` can either be a float [0, 1] (percentage of whole screen)
                   ;;                    or a intereger (1, ∞] (rows/columns)
                   {:id :scopes
                    :size 0.25}
                   {:id :breakpoints
                    :size 0.25}
                   {:id :stacks
                    :size 0.25}
                   {:id :watches
                    :size 0.25}]
                :size 40
                :position :left}
             :tray
               {:elements [:repl]
                :size 10
                :position :bottom}
             :floating {:max_height nil
                        :max_width nil
                        :mappings
                          {:close [:q :<Esc>]}}
             :windows {:indent 1}}]
    (dapui.setup opt)

    (dk [:n]
        {:d {:name :Dap
             :t [dapui.toggle "Toggle dap-ui"]}}
        {:prefix :<leader>})))

{1 :rcarriga/nvim-dap-ui
 :dependencies [:mfussenegger/nvim-dap]
 : config}
