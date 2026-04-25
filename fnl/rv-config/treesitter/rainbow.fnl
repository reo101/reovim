(local capabilities (require :rv-config.treesitter.capabilities))

(fn get-effective-bufnr [bufnr]
  (let [mode (vim.api.nvim_get_mode)
        mode-name (or (. mode :mode) "")]
    (if (= mode-name "c")
        (let [cmd-bufnr
                (or
                  (let [(ok? ui2) (pcall require :vim._core.ui2)]
                    (if ok? (. (. ui2 :bufs) :cmd) nil))
                  (let [(ok? shared) (pcall require :vim._extui.shared)]
                    (if ok? (. (. shared :bufs) :cmd) nil)))]
          (if (and cmd-bufnr (not= cmd-bufnr -1))
              cmd-bufnr
              bufnr))
        bufnr)))

fn rainbow-buffer-allowed? [bufnr]
 (let [effective-bufnr (get-effective-bufnr bufnr)]
   (and effective-bufnr
        (capabilities.normal-file-buffer? effective-bufnr)
        (not= (. vim.bo effective-bufnr :filetype) "cmd")
        (capabilities.buffer-has-parser? effective-bufnr))))

;; Seed a safe default early so plugin FileType autocmds never touch ui2 `cmd`.
(let [conf (or (. vim.g :rainbow_delimiters) {})]
  (tset conf :condition rainbow-buffer-allowed?)
  (tset vim.g :rainbow_delimiters conf))

(fn after []
  (let [dk (require :def-keymaps)
        rainbow-delimiters (require :rainbow-delimiters)
        opt {:strategy {""   (. rainbow-delimiters :strategy :global)
                        :vim (. rainbow-delimiters :strategy :local)}
             :query    {""   :rainbow-delimiters
                        :lua :rainbow-blocks}
             :priority {:agda 500
                        :fsharp 200}
             :highlight [:RainbowDelimiterRed
                         :RainbowDelimiterYellow
                         :RainbowDelimiterBlue
                         :RainbowDelimiterOrange
                         ;; :RainbowDelimiterGreen
                         :RainbowDelimiterViolet
                         :RainbowDelimiterCyan]}]
    (tset vim.g :rainbow_delimiters opt)

    (dk :n
        {:t {:group :Toggle
             :s {:group  :TreeSitter
                 :r [#(rainbow-delimiters.toggle 0) "Rainbow Delimiters"]}}}
        {:prefix :<leader>})))


{:src "https://github.com/HiPhish/rainbow-delimiters.nvim"
 :data {:dep_of [:indent-blankline.nvim]
        :event :BufRead
        : after}}
