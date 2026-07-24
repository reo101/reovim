(fn after []
  (let [jjannotate (require :jjannotate)
        dk (require :def-keymaps)
        opt {:view
             {;; Whether to collapse repeating lines into a single line
              :collapse_repeating_lines true
              ;; Whether to highlight all lines changed by cursor's change id
              :highlight_changed_lines true
              ;; How to highlight lines related to current change
              ;; * "none": no highlighting
              ;; * "bold": bold text
              :highlight_current_change "bold"
              ;; Color palette for annotate highlights
              ;; "auto": pick dark/light palette based on vim.o.background (live-updates on ColorScheme/OptionSet)
              ;; {:auto true :multiplier {:sat 1.0 :light 1.0}} <- same as "auto", but with a color multiplier
              ;; Or pass a `jjannotate.Config.ResolvedPalette` to set colors directly
              :palette "auto"}
             ;; Disable any mapping by setting it to `false`
             :mappings
             {;; Close the annotate window
              :close "q"
              ;; Show revision under the cursor in a new tab
              :show "<CR>"
              ;; Follow revision under the cursor and re-run annotate in a new tab
              :follow "f"}}]
    (tset vim.g :jjannotate_opts opt)

    (dk :n
        {:g {:group :Git
             :o [#(jjannotate.open) "Open JJ Annotate"]
             :t [#(jjannotate.toggle) "Toggle JJ Annotate"]}}
        {:prefix :<leader>})))

{:src "https://tangled.org/ronshavit.com/jjannotate.nvim"
 :data {:keys [:<leader>g]
        : after}}
