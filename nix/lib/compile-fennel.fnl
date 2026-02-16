;; Add nfnl to `package.path`
(let [nfnl-path (os.getenv :NFNL_PATH)]
  (when nfnl-path
    (set package.path (.. nfnl-path "/lua/?.lua;" package.path))))

;; Trust `.nfnl.fnl`
(let [nfnl-config-path (.. (vim.fn.getcwd) :/.nfnl.fnl)]
  (when (= (vim.fn.filereadable nfnl-config-path) 1)
    (let [bufnr (vim.fn.bufadd nfnl-config-path)]
      (tset vim.bo bufnr :swapfile false)
      (vim.fn.bufload bufnr)
      (pcall vim.secure.trust {: bufnr :action :allow}))))

;; Compile all fennel files
(let [nfnl-api (require :nfnl.api)
      results (nfnl-api.compile-all-files ".")]
  ;; Write results for analysis
  (let [result-file (io.open :/tmp/nfnl-compile-results.lua :w)]
    (when result-file
      (result-file:write (vim.inspect results))
      (result-file:close)))

  ;; Process results
  (var error-count 0)
  (var total-count 0)
  (when (= (type results) :table)
    (each [k v (pairs results)]
      (set total-count (+ total-count 1))
      (when (= v.ok false)
        (set error-count (+ error-count 1))
        (print (.. "ERROR: Failed to compile " (tostring k) ": " (tostring (or v.err "unknown error")))))))

  (print (.. "FENNEL_COMPILE_INFO: " total-count " file(s) processed, " error-count " error(s)"))

  (if (> error-count 0)
      (do
        (print "FENNEL_COMPILE_FAILED: Build aborted due to compilation errors")
        (vim.cmd :cq)
        (os.exit 1))
      (print "FENNEL_COMPILE_SUCCESS: All files compiled successfully")))
