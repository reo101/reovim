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
    (let [cmd (.. "put =execute('" input.args "')")]
      (vim.cmd cmd)))
  {:nargs 1})

(local group (vim.api.nvim_create_augroup
               :reovim-autocommands
               {:clear true}))

;; Terminal utilities
(vim.api.nvim_create_autocmd
  :TermOpen
  {:pattern :*
   : group
   :callback
     #(do
        (vim.keymap.set
          :t
          :<Esc>
          :<C-\><C-n>
          {:buffer true})
        (vim.cmd ":startinsert")
        (vim.cmd "setlocal listchars= nonumber norelativenumber"))})

;;; Turn off hlsearch in Insert Mode
(vim.api.nvim_create_autocmd :InsertEnter
                             {:pattern :*
                              : group
                              :command "setlocal nohlsearch"})

;;; Highlight yanked text
(vim.api.nvim_create_autocmd :TextYankPost
                             {:pattern :*
                              : group
                              :callback #(vim.highlight.on_yank {:higroup :IncSearch
                                                                 :timeout 300})})

;;; Save Shada
(vim.api.nvim_create_autocmd :VimLeave
                             {:pattern :*
                              : group
                              :command ":wshada!"})

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

(dk [:n]
    {:w ["<C-w>" :Window]}
    {:prefix :<leader>})
