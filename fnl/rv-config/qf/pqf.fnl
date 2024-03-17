(fn config []
  (let [pqf (require :pqf)
        opt {:max_filename_length 0
             :show_multiple_lines true
             :signs {:error :E :hint :H :info :I :warning :W}}]
    (pqf.setup opt)))

{1 :yorickpeterse/nvim-pqf
 : config}
