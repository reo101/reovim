(fn config []
  (let [typst-preview (require :typst-preview)
        dk (require :def-keymaps)
        opt {;; file opened by pdf viewer
             :output_file
               #(let [core (require :core)]
                 (.. (core.file.root_path)
                     "/output.pdf"))
             ;; how to redirect output files
             :redirect_output
               (fn [original-file output-file]
                 (vim.cmd
                   (string.format
                     "silent !ln -s %s %s"
                     original-file
                     output-file)))
             ;; how to preview the pdf file
             :preview
               (fn [output-file]
                 (let [core (require :core)]
                   (core.job.spawn
                     :mimeopen
                     [output-file]
                     {}
                     #nil
                     #nil
                     #nil)))
             ;; whether to clean all pdf files on VimLeave
             :clean_temp_pdf true}]
    (typst-preview.setup opt)))

[{1 :SeniorMars/typst.nvim}
 {1 :niuiic/typst-preview.nvim
  :dependencies [:niuiic/core.nvim]
  :ft ["typst"]
  : config}]
