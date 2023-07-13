(local dk (require :def-keymaps))

(local reflect-session {:id nil :mode :compile})
(fn new-or-attach-reflect []
  (let [reflect (require :hotpot.api.reflect)
        with-session-id
         (if reflect-session.id
           (fn [f]
             (f reflect-session.id))
           ;; else
           (fn [f]
             (let [buf (vim.api.nvim_create_buf true true)
                   id  (reflect.attach-output buf)]
               (set reflect-session.id id)
               (f id)
               (vim.schedule
                 #(do
                    (vim.api.nvim_command "botright vnew")
                    (vim.api.nvim_win_set_buf
                      (vim.api.nvim_get_current_win)
                      buf)
                    (vim.api.nvim_create_autocmd
                      :BufWipeout
                      {:buffer buf
                       :once true
                       :callback #(set reflect-session.id nil)}))))))]
    (with-session-id
      (fn [session-id]
        (reflect.set-mode session-id reflect-session.mode)
        (reflect.attach-input session-id 0)))))
(dk :v
    {:pr [new-or-attach-reflect
          "New or Attach Reflect"]}
    {:prefix :<leader>})

(fn swap-reflect-mode []
  (let [reflect (require :hotpot.api.reflect)]
    (when reflect-session.id
      (set reflect-session.mode
        (if (= reflect-session.mode :compile) :eval :compile))
      (reflect.set-mode reflect-session.id reflect-session.mode))))
(dk :n
    {:px [swap-reflect-mode "Swap Reflect Mode"]}
    {:prefix :<leader>})
