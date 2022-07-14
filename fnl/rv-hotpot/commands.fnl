(local dk (require :def-keymaps))

(fn open_cache []
  (let [cache-path-fn (. (require :hotpot.api.cache)
                         :cache-path-for-fnl-file)
        fnl-file (vim.fn.expand "%:p")
        lua-file (cache-path-fn fnl-file)]
    (if lua-file
      (vim.cmd (.. ":new " lua-file))
      (print "No matching cache file for current file"))))

;; print(require('hotpot.api.compile')['compile-buffer'](0))
(fn compile-buffer [?bufnr]
  (let [compile-api (require :hotpot.api.compile)
        compile-buffer (. compile-api :compile-buffer)]
    (compile-buffer (or ?bufnr 0))))

(dk
  :n
  {:p {:name :HotPot
       :c [open_cache "Open Cache"]
       :b [compile-buffer "Compile Buffer"]}}
  :<leader>)

;; print(require('hotpot.api.eval')['eval-selection']())
(fn eval-selection []
  (let [eval-api (require :hotpot.api.eval)
        eval-selection (. eval-api :eval-selection)]
    (eval-selection)))

;; print(require('hotpot.api.compile')['compile-selection']())
(fn compile-selection []
  (let [compile-api (require :hotpot.api.compile)
        compile-selection (. compile-api :compile-selection)]
    (compile-selection)))

(dk
  :v
  {:p {:name :HotPot
       :e [eval-selection "Eval Selection"]
       :c [compile-selection "Compile Selection"]}}
  :<leader>)

(fn fnl-do [ok code noformat]
  (set vim.wo.scrollbind true)
  (var buf vim.g.luascratch)
  (when (not buf)
    (set buf (vim.api.nvim_create_buf false true))
    (set vim.g.luascratch buf)
    (vim.api.nvim_buf_set_option buf :filetype :lua))
  (let [nextLine (vim.gsplit code "\n" true)
        lines (icollect [v nextLine]
                v)]
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (let [cmd vim.cmd
          wnum (vim.fn.bufwinnr buf)
          jump-or-split (if (= -1 wnum) (.. :vs|b buf) (.. wnum "wincmd w"))]
      (cmd jump-or-split)
      (if (and ok (not noformat)) (cmd "%!stylua /dev/stdin"))
      (cmd "setl nofoldenable")
      (vim.fn.setpos "." [0 0 0 0]))))

;; https://github.com/neovim/neovim/pull/13896
(fn get-range [args]
  (let [r1 args.line1
        r2 args.line2
        ;; https://github.com/neovim/neovim/pull/13896#issuecomment-774680224
        [_ v1] (vim.fn.getpos :v)
        [_ v2] (vim.fn.getcurpos)]
    (if (not= v2 v1)
      (values (math.min v1 v2) (math.max v1 v2))
      (values r1 r2))))

(fn FnlEval [args]
  (if (= vim.bo.filetype :fennel)
    (let [(start stop) (get-range args)
          {: eval-range} (require :hotpot.api.eval)
          (any) (eval-range 0 start stop)]
      (fnl-do true (vim.inspect any) true))))

(fn FnlCompile [args]
  (if (= vim.bo.filetype :fennel)
    (let [(start stop) (get-range args)
          {: compile-range} (require :hotpot.api.compile)
          (ok code) (compile-range 0 start stop)]
      (fnl-do ok code))))

;; {: FnlEval : FnlCompile}
(vim.api.nvim_create_user_command
  :FnlEval
  FnlEval
  {})
(vim.api.nvim_create_user_command
  :FnlCompile
  FnlCompile
  {})
