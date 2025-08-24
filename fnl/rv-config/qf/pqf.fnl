(fn after []
  (let [pqf (require :pqf)
        opt {:max_filename_length 0
             :show_multiple_lines true
             :signs {:error :E :hint :H :info :I :warning :W}}]
    (pqf.setup opt)))

{:src "https://github.com/yorickpeterse/nvim-pqf"
 :data {: after}}
