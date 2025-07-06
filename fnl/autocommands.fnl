(import-macros
  {: >==}
  :init-macros)

(local dk (require :def-keymaps))

;; (vim.api.nvim_create_autocmd :FileType
;;                              {:pattern :lspinfo
;;                               :callback #(vim.api.nvim_buf_set_keymap
;;                                            0
;;                                            :n
;;                                            :q
;;                                            ":q<CR>"
;;                                            {:silent true})})

;;; Dump command output in buffer
(vim.api.nvim_create_user_command
  :Dump
  (fn [input]
    (let [output (vim.fn.execute input.args)
          lines (vim.split output "\n" true)]
      (vim.api.nvim_put lines "l" true true)))
  {:nargs 1
   :complete :command})

(local group (vim.api.nvim_create_augroup
               :reovim-autocommands
               {:clear true}))

;; Terminal utilities
(vim.keymap.set
  :t
  :<Esc><Esc>
  :<C-\><C-n>)
(vim.api.nvim_create_autocmd
  :TermOpen
  {:pattern :*
   : group
   :callback
     #(do
        (vim.cmd ":startinsert")
        (vim.cmd "setlocal listchars= nonumber norelativenumber"))})

;;; Turn off hlsearch in Insert Mode
(vim.api.nvim_create_autocmd
  :InsertEnter
  {:pattern :*
   : group
   :command "setlocal nohlsearch"})

;;; Highlight yanked text
(vim.api.nvim_create_autocmd
  :TextYankPost
  {:pattern :*
   : group
   :callback #(vim.highlight.on_yank
                {:higroup :IncSearch
                 :timeout 300})})

;;; Save Shada
(vim.api.nvim_create_autocmd
  :VimLeave
  {:pattern :*
   : group
   :command ":wshada!"})

; ;;; Change pwd when opened with a directory argument
; (vim.api.nvim_create_autocmd
;   :VimEnter
;   {:pattern :*
;    : group
;    :callback #(vim.api.nvim_set_current_dir (vim.fn.expand "%:p:h"))})

;;; Set preffered shiftwidth for some filetypes
(fn set-shiftwidth [filetype shiftwidth]
  (vim.api.nvim_create_autocmd
    :FileType
    {:pattern filetype
     : group
     :callback #(vim.cmd
                  (string.format
                    " setlocal expandtab tabstop=%d shiftwidth=%d softtabstop=%d "
                    shiftwidth
                    shiftwidth
                    shiftwidth))}))

(>== [:haskell
      :norg
      :xml
      :xslt
      :xsd
      :fennel
      ;; :javascript
      ;; :javascriptreact
      ;; :javascript.jsx
      ;; :typescript
      ;; :typescriptreact
      ;; :typescript.tsx
      :json
      :css
      :html
      :terraform
      :scheme
      :nix
      :agda]
     #(set-shiftwidth $1 2))

(>== [:yaml
      :rust]
     #(set-shiftwidth $1 4))

(vim.filetype.add {:pattern {"%.env%.[%w_.-]+" :sh}})

(dk :n
    {:w ["<C-w>" :Window]}
    {:prefix :<leader>})

(local hydra (require :hydra))

(fn mk-traversing-hydra [name prev-fn next-fn]
  (hydra {:name (.. "`[`/`]` jumper for " name)
          :mode :n
          :config {:color :red}
                   ;; NOTE: allow for UI updates
                   ;; :on_key #(vim.wait 50)}
          :heads [["[" prev-fn {:desc "Previous"}]
                  ["]" next-fn {:desc "Next"}]]}))

(fn mk-traversing-keymap [name letter prev-fn next-fn head-fn tail-fn]
  (local traversing-hydra (mk-traversing-hydra name prev-fn next-fn))
  (dk :n
      (vim.tbl_extend
        :error
        {(.. "[" letter) [#(do (prev-fn) (traversing-hydra:activate)) (.. "Previous " name)]
         (.. "]" letter) [#(do (next-fn) (traversing-hydra:activate)) (.. "Next " name)]}
        {(.. "[" (letter:upper)) (when head-fn [#(do (head-fn) (traversing-hydra:activate)) (.. "Head " name)])}
        {(.. "]" (letter:upper)) (when next-fn [#(do (tail-fn) (traversing-hydra:activate)) (.. "Tail " name)])})
      {:noremap true}))

(fn cmd [opts]
  (local (ok err) (pcall vim.api.nvim_cmd opts {}))
  (when (not ok)
    (vim.api.nvim_echo [[(err:sub (+ (length "Vim:") 1))]]
                       true
                       {:err true})))

(mk-traversing-keymap
  "buffer"
  :b
  vim.cmd.bprev
  vim.cmd.bnext
  vim.cmd.bfirst
  vim.cmd.blast)
;; TODO: tags?
(mk-traversing-keymap
  "tab"
  :t
  vim.cmd.tprev
  vim.cmd.tnext
  vim.cmd.tfirst
  vim.cmd.tlast)
(mk-traversing-keymap
  "diagnostic"
  :d
  #(vim.diagnostic.jump {:count vim.v.count1})
  #(vim.diagnostic.jump {:count (- vim.v.count1)})
  #(vim.diagnostic.jump {:count vim._maxint :wrap false})
  #(vim.diagnostic.jump {:count (- vim._maxint) :wrap false}))
(mk-traversing-keymap
  "quickfix"
  :q
  #(cmd {:cmd :cprev  :count vim.v.count1})
  #(cmd {:cmd :cnext  :count vim.v.count1})
  #(cmd {:cmd :cfirst :count (when (not= vim.v.count 0) vim.v.count)})
  #(cmd {:cmd :clast  :count (when (not= vim.v.count 0) vim.v.count)}))
(mk-traversing-keymap
  "locationlist"
  :l
  #(cmd {:cmd :lprev  :count vim.v.count1})
  #(cmd {:cmd :lnext  :count vim.v.count1})
  #(cmd {:cmd :lfirst :count (when (not= vim.v.count 0) vim.v.count)})
  #(cmd {:cmd :llast  :count (when (not= vim.v.count 0) vim.v.count)}))
(mk-traversing-keymap
  "argument"
  :a
  #(cmd {:cmd :prev :count vim.v.count1})
  ;; count doesn't work with :next, must use range. See #30641.
  #(cmd {:cmd :next :range [vim.v.count1]})
  #(if (not= vim.v.count 0)
       (cmd {:cmd :argument :count vim.v.count})
       (cmd {:cmd :rewind}))
  #(if (not= vim.v.count 0)
       (cmd {:cmd :argument :count vim.v.count})
       (cmd {:cmd :last})))
