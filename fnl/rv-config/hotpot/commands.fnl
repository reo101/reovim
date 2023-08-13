(import-macros
  {: imap}
  :init-macros)

(local dk (require :def-keymaps))

(local {: eval-buffer
        : eval-selection} (require :hotpot.api.eval))

(local {: compile-buffer
        : compile-selection} (require :hotpot.api.compile))

(fn pecho [ok? ...]
  "`vim.notify` vargs, as Hint or Error, depending on `ok?`"
  (let [{: view} (require :fennel)
        hl-group (if ok? :DiagnosticHint :DiagnosticError)
        level (. vim.log.levels
                 (if ok? :HINT :ERROR))
        output [[(table.concat
                   (icollect [_ elem (ipairs [...])]
                     (match (type elem)
                        :table (view elem)
                        _ (tostring elem)))
                   "\n")]]]
    (vim.api.nvim_echo output level {})))

(fn open_cache []
  (let [cache-path-fn (. (require :hotpot.api.cache)
                         :cache-path-for-fnl-file)
        fnl-file (vim.fn.expand "%:p")
        lua-file (cache-path-fn fnl-file)]
    (if lua-file
      (vim.cmd (.. ":new " lua-file))
      (vim.notify "No matching cache file for current file"))))

(dk [:n]
    {:p {:name :HotPot
         :e {:name :Evaluate
             :b [#(pecho (eval-buffer 0)) "Entire buffer"]}
         :c {:name :Compile
             :b [#(pecho (compile-buffer 0)) "Entire buffer"]}
         :h [open_cache "Open cache"]}}
    {:prefix :<leader>})

(dk [:v]
    {:p {:name :HotPot
         :e {:name :Evaluate
             :s [#(pecho (eval-selection)) "Selection"]}
         :c {:name :Compile
             :s [#(pecho (compile-selection)) "Selection"]}}}
    {:prefix :<leader>})

(fn fnl-do [ok code noformat]
  (set vim.wo.scrollbind true)
  (var buf vim.g.luascratch)
  (when (not buf)
    (set buf (vim.api.nvim_create_buf false true))
    (set vim.g.luascratch buf)
    (vim.api.nvim_buf_set_option buf :filetype :lua))
  (let [lines (vim.split code "\n" true)]
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (let [cmd vim.cmd
          wnum (vim.fn.bufwinnr buf)
          jump-or-split (if (= -1 wnum)
                            (.. "vs | buffer " buf)
                            (.. wnum "wincmd w"))]
      (cmd jump-or-split)
      (when (and ok
                 (not noformat))
        (cmd "%!stylua /dev/stdin"))
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
  (when (= vim.bo.filetype :fennel)
    (let [(start stop) (get-range args)
          {: eval-range} (require :hotpot.api.eval)
          (any) (eval-range 0 start stop)]
      (fnl-do true (vim.inspect any) true))))

(fn FnlCompile [args]
  (when (= vim.bo.filetype :fennel)
    (let [(start stop) (get-range args)
          {: compile-range} (require :hotpot.api.compile)
          (ok code) (compile-range 0 start stop)]
      (fnl-do ok code))))

(vim.api.nvim_create_user_command :FnlEval    FnlEval    {})
(vim.api.nvim_create_user_command :FnlCompile FnlCompile {})
