(let [{: heirline
       : conditions
       : utils
       : colors
       : heirline-components
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      resolve-sign
      (fn [bufnr lnum]
        (local row (- lnum 1))
        (local extmarks
               (vim.api.nvim_buf_get_extmarks
                 bufnr
                 (- 1)
                 [row 0]
                 [row (- 1)]
                 {:details true
                  :type :sign}))
        (var ret nil)
        (each [_ extmark (pairs extmarks)]
          (local sign-def (. extmark 4))
          (when (and sign-def.sign_text
                     (or (not ret)
                         (< ret.priority sign-def.priority)))
            (set ret sign-def)))
        (when ret
          {:text   ret.sign_text
           :texthl ret.sign_hl_group}))

      provider
      (fn [self]
        (let [self (or self {})
              opts {:thousands false
                    :culright true
                    :escape false}
              (lnum rnum virtnum) (values vim.v.lnum vim.v.relnum vim.v.virtnum)
              (num relnum) (values (vim.opt.number:get) (vim.opt.relativenumber:get))
              bufnr (or self.bufnr (vim.api.nvim_get_current_buf))
              sign (and (: (vim.opt.signcolumn:get) :find :nu)
                        (resolve-sign bufnr lnum))
              str (if (not= virtnum 0)
                      "%="
                      sign
                      (do
                        (var str sign.text)
                        (when sign.texthl
                          (set str (.. "%#" sign.texthl "#" str "%*")))
                        (set str (.. "%=" str))
                        str)
                      (and (not num)
                           (not relnum))
                      "%="
                      (do
                       (var cur (if relnum
                                    (if (> rnum 0)
                                        rnum
                                        ;; else
                                        (if num
                                            lnum
                                            ;; else
                                            0))
                                    ;; else
                                    lnum))
                       (when (and opts.thousands (> cur 999))
                         (set cur
                              (-> cur
                                  (: :reverse)
                                  (: :gsub "%d%d%d" (.. "%1" opts.thousands))
                                  (: :reverse)
                                  (: :gsub (.. "^%" opts.thousands) ""))))
                       (if (and (= rnum 0)
                                (not opts.culright)
                                relnum)
                           (.. cur "%=")
                           (.. "%=" cur))))
              str (.. str " ")]
          str))

      ;; Numbercolumn
      Numbercolumn
      {:condition #(or (vim.opt.number:get)
                       (vim.opt.relativenumber:get))
       : provider
       :on_click {:name :number_click
                  :callback
                    (fn [...]
                      (let []
                        nil))}}]

     {: Numbercolumn})
