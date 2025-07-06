(fn after []
  (let [typst-preview (require :typst-preview)
        dk (require :def-keymaps)
        opt {;; Setting this true will enable printing debug information with print()
             :debug true
             ;; Custom format string to open the output link provided with %s
             ;; Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
             :open_cmd "firefox %s -P typst-preview --class typst-preview"
             ;; Setting this to 'always' will invert black and white in the preview
             ;; Setting this to 'auto' will invert depending if the browser has enable
             ;; dark mode
             :invert_colors :never
             ;; Whether the preview will follow the cursor in the source file
             :follow_cursor true
             ;; Provide the path to binaries for dependencies.
             ;; Setting this will skip the download of the binary by the plugin.}])
             ;; Warning: Be aware that your version might be older than the one
             ;; required.
             :dependencies_bin {:typst-preview :typst-preview
                                :websocat :websocat}
             ;; This function will be called to determine the root of the typst project
             :get_root (fn [bufnr-of-typst-buffer]
                         (vim.fn.getcwd))
             ;; This function will be called to determine the main file of the typst
             ;; project.
             :get_main_file (fn [path-of-buffer]
                              path-of-buffer)}]
    (typst-preview.setup opt)))

[{:src "https://github.com/SeniorMars/typst.nvim"
  :data {:ft ["typst"]}}
 {:src "https://github.com/chomosuke/typst-preview.nvim"
  :version :v1.3.4
  :data {:ft ["typst"]
         :build #(-> (require :typst-preview) (. :update) (#($)))
         : after}}]
