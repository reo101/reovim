(let [{: heirline
       : conditions
       : utils
       : colors
       : navic
       : luasnip
       : dap
       : icons}
      (require :rv-config.heirline.common)

      ;;; Components

      {:Filetype-Icon FiletypeIcon}
      (require :rv-config.heirline.components.file)

      TablineBufnr
      {:provider (fn [self]
                   (tostring (.. self.bufnr ". ")))
       :fl :Comment}

      TablineFilename
      {:provider (fn [self]
                   (let [filename self.filename
                         filename (if
                                    (= filename "")
                                    "[No Name]"
                                    ;; else
                                    (vim.fn.fnamemodify filename ":t"))]
                     filename))
       :hl (fn [self]
             {:bold (or
                      self.is_active
                      self.is_visible)
              :italic true})}

      TablineFileFlags
      (vim.tbl_extend
        :error
        {}
        [{:condition (fn [self]
                       (vim.api.nvim_buf_get_option self.bufnr :modified))
          :provider "[+]"
          :hl {:fg :green}}
         {:condition (fn [self]
                       (or
                         (not (vim.api.nvim_buf_get_option self.bufnr :modifiable))
                         (vim.api.nvim_buf_get_option self.bufnr :readonly)))
          :provider (fn [self]
                      (if
                        (= (vim.api.nvim_buf_get_option self.bufnr :buftype) :terminal)
                        "  "
                        ;; else
                        ""))
          :hl {:fg :orange}}])

      TablineFilenameBlock
      (vim.tbl_extend
        :error
        {:init (fn [self]
                (tset self :filename (vim.api.nvim_buf_get_name self.bufnr)))
         :hl (fn [self]
               (if
                 self.is_active
                 :TabLineSel
                 (not (vim.api.nvim_buf_is_loaded self.bufnr))
                 {:fg :gray}
                 ;; else
                 :TabLine))
         :on_click {:callback (fn [_ minwid _ button]
                                (if
                                  (= button :m)
                                  (vim.api.nvim_buf_delete minwid {:force false})
                                  ;; else
                                  (vim.api.nvim_win_set_buf 0 minwid)))
                    :minwid (fn [self]
                              self.bufnr)
                    :name :heirline_tabline_buffer_callback}}
        [TablineBufnr
         FiletypeIcon
         TablineFilename
         TablineFileFlags])

      TablineCloseButton
      (vim.tbl_extend
        :error
        {:condition (fn [self]
                      (not (vim.api.nvim_buf_get_option self.bufnr :modified)))}
        [{:provider " "}
         {:provider "󰅙"
          :hl {:fg :gray}
          :on_click {:callback (fn [_ minwid]
                                 (vim.api.nvim_buf_delete minwid {:force false}))
                     :minwid (fn [self]
                               self.bufnr)
                     :name :heirline_tabline_close_buffer_callback}}])

      TablineBufferBlock
      (utils.surround
        ["" ""]
        (fn [self]
            (if
              self.is_active
              (. (utils.get_highlight :TabLineSel) :bg)
              ;; else
              (. (utils.get_highlight :TabLine) :bg)))
        [TablineFilenameBlock
         TablineCloseButton])

      BufferLine
      (utils.make_buflist
        TablineBufferBlock
        {:provider ""
         :hl {:fg :gray}}
        {:provider ""
         :hl {:fg :gray}})

      Tabpage
      {:provider (fn [self]
                   (.. "%" self.tabnr "T " self.tabnr " %T"))
       :hl (fn [self]
             (if
               (not self.is_active)
               :TabLine
               ;; else
               :TabLineSel))}

      TabpageClose
      {:provider "%999X 󰅙 %X"
       :hl :TabLine}

      TabPages
      (vim.tbl_extend
        :error
        {:condition #(> (length (vim.api.nvim_list_tabpages)) 1)}
        [{:provider "%="}
         (utils.make_tablist Tabpage)
         TabpageClose])

      TabLineOffset
      {:condition (fn [self]
                    (let [win (. (vim.api.nvim_tabpage_list_wins 0) 1)
                          bufnr (vim.api.nvim_win_get_buf win)]
                      (tset self :winid win)
                      (if
                        (= (. vim.bo bufnr :filetype) :NvimTree)
                        (do
                          (tset self :title :NvimTree)
                          true)
                        (= (. vim.bo bufnr :filetype) :neo-tree)
                        (do
                          (tset self :title :NeoTree)
                          true)
                        ;; else
                        false)))
       :provider (fn [self]
                   (let [title self.title
                         width (vim.api.nvim_win_get_width self.winid)
                         pad (math.ceil (/ (- width (length title)) 2))
                         pad (string.rep " " pad)]
                     (.. pad title pad)))
       :hl (fn [self]
             (if
               (= (vim.api.nvim_get_current_win) self.winid)
               :TabLineSel
               ;; else
               :TabLine))}

      ;; Default Tabline
      DefaultTabline
      (vim.tbl_extend
        :error
        {:init (fn [self]
                 (local dk (require :def-keymaps))
                 (dk :n
                     {:b {:group :Buffer
                          :s ["<Cmd>:w<CR>" :Save]
                          :e ["<Cmd>:e<CR>" :Edit]}}
                     {:prefix :<leader>})
                 (dk :n
                     {:<A-Left>  #(vim.cmd ":bprev")
                      :<A-Right> #(vim.cmd ":bnext")}))}
        [TabLineOffset
         BufferLine
         TabPages])]

  {: DefaultTabline})
