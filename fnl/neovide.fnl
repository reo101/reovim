(local dk (require :def-keymaps))

(when vim.g.neovide
  (let [settings [:floating_shadow true
                  :floating_z_height 10
                  :light_angle_degrees 45
                  :light_radius 5
                  :scroll_animation_length 0.3
                  :scroll_animation_far_lines 1
                  :hide_mouse_when_typing true]]
                  ;; :input_macos_alt_is_meta true]]
    (each [setting value (pairs settings)]
      (tset vim.g
            (.. :neovide_
                setting)
            value)))

  ;; Zooming
  (set vim.g.neovide_scale_factor 1.0)
  (fn change-scale-factor [delta]
    (set vim.g.neovide_scale_factor
         (* vim.g.neovide_scale_factor
            delta)))
  (dk [:n]
      {:<M-S-Up>   #(change-scale-factor 1.25)
       :<M-S-Down> #(change-scale-factor 0.8)}))
