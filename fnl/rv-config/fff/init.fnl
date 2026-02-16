(local {: autoload} (require :nfnl.module))

(fn after []
  (let [fff (autoload :fff)
        dk (require :def-keymaps)
        opt {:lazy_sync true}]
    (tset _G :fff opt)

    (dk :n
        {:F [#(fff.find_files) "FFFind files"]}
        {:prefix :<leader>})))

{:src "https://github.com/dmtrKovalenko/fff.nvim"
 :data {: after
        :build "nix run .#release"}}
