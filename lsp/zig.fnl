;; NOTE: see <https://github.com/ziglang/zig.vim/issues/51>
(tset vim.g :zig_fmt_autosave 0)

{:cmd [:zls]
 :filetypes [:zig
             :zir]
 :root_markers [:zls.json]
 :single_file_support true}
