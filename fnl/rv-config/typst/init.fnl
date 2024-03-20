(fn config []
  (let [typst-preview (require :typst-preview)
        dk (require :def-keymaps)
        opt {;; Setting this true will enable printing debug information with print()
             :debug false
             ;; Custom format string to open the output link provided with %s
             ;; Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
             :open_cmd nil
             ;; Provide the path to binaries for dependencies.
             ;; Setting this will skip the download of the binary by the plugin.}])
             ;; Warning: Be aware that your version might be older than the one
             ;; required.
             :dependencies_bin {:typst-preview nil
                                :websocat nil}
             ;; Setting this to 'always' will invert black and white in the preview
             ;; Setting this to 'auto' will invert depending if the browser has enable}])
             ;; dark mode
             :invert_colors :never
             ;; This function will be called to determine the root of the typst project
             :get_root (fn [bufnr-of-typst-buffer]
                         (vim.fn.getcwd))}]
    (typst-preview.setup opt)))

[{1 :SeniorMars/typst.nvim
  :ft ["typst"]}
 {1 :chomosuke/typst-preview.nvim
  :dependencies [:niuiic/core.nvim]
  :tag :v0.1.5
  :ft ["typst"]
  :build #((. (require :typst-preview) :update))
  : config}]
