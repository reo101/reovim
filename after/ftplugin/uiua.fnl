(tset vim.opt_local :comments ":#")
(tset vim.opt_local :commentstring "# %s")

(tset vim.opt_local :errorformat
  ["%AError: %m"
   "%C  at %f:%l:%c"
   "%C at %f:%l:%c"
   "%Z"
   "%f:%l:%c: %t%*[^:]: %m"
   "%f:%l:%c: %m"
   "%-G%*[ ]|%.%#"
   "%-G%*[ ]^%#"
   "%-G%*[ ]~%#"])

(local group (vim.api.nvim_create_augroup
               :ReovimUiuaCharSpaceHighlight
               {:clear true}))

(vim.cmd
  "
  hi def uiuaRed             ctermfg=197 guifg=#ed5e6a
  hi def uiuaOrange          ctermfg=166 guifg=#ff8855
  hi def uiuaYellow          ctermfg=221 guifg=#f0c36f
  hi def uiuaBeige           ctermfg=222 guifg=#d7be8c
  hi def uiuaGreen           ctermfg=118 guifg=#95d16a
  hi def uiuaAqua            ctermfg=51  guifg=#6ad9ce
  hi def uiuaBlue            ctermfg=39  guifg=#54b0fc
  hi def uiuaIndigo          ctermfg=62  guifg=#8078f1
  hi def uiuaPurple          ctermfg=129 guifg=#cc6be9
  hi def uiuaPink            ctermfg=207 guifg=#f576d8
  hi def uiuaLightPink       ctermfg=218 guifg=#f5a9b8
  hi def uiuaFaded           ctermfg=244 guifg=#888888

  hi def uiuaForegroundDark  guifg=#d1daec
  hi def uiuaForegroundLight guifg=#334444
  ")

(local mappings
       {:identifier        :uiuaForeground ;; old
        :macro_special     :uiuaForeground ;; old
        :punctuation       :uiuaForeground ;; old
        :delimiters        :uiuaForeground ;; old

        :stack_function    :uiuaForeground
        :noadic_function   :uiuaRed
        :monadic_function  :uiuaGreen
        :dyadic_function   :uiuaBlue
        :triadic_function  :uiuaIndigo
        :tetradic_function :uiuaPink
        :pentadic_function :uiuaForeground
        :monadic_modifier  :uiuaYellow
        :dyadic_modifier   :uiuaPurple
        :triadic_modifier  :uiuaLightPink

        :uiua_constant     "@constant"
        :uiua_number       :uiuaOrange
        :num_shadow        :uiuaForeground ;; old
        :esc               :uiuaAqua ;; old
        :char_space        :IncSearch ;; old
        :char              :uiuaAqua ;; old
        :fmt               :uiuaAqua ;; old
        :uiua_string       :uiuaAqua
        :unicode_literal   :uiuaForeground ;; old

        :optional_arg      :uiuaGreen ;; old
        :signature         :uiuaForeground ;; old
        :mod_punct         :uiuaForeground ;; old
        :mod_name          :uiuaBeige ;; old
        :mod_member_name   :uiuaForeground ;; old
        :mod_bind          :uiuaBeige ;; old
        :mod_ref           :uiuaBeige ;; old
        :mod_import_member :uiuaForeground ;; old
        :debug             :uiuaForeground ;; old
        :label             :uiuaGreen ;; old
        :semantic_comment  :uiuaFaded ;; old
        :signature_comment :uiuaFaded ;; old
        :comment           :uiuaFaded}) ;; old

(each [name link (pairs mappings)]
  (vim.api.nvim_set_hl 0 (.. "@lsp.type." name ".uiua") {: link}))
