(local M {})

(fn M.config []
    (let [tokyonight (require :tokyonight)
          opt {;; The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
               :style :night
               ;; The theme is used when the background is set to light
               :light_style :day
               ;; Enable this to disable setting the background color
               :transparent false
               ;; Configure the colors used when opening a `:terminal` in Neovim
               :terminal_colors true
               ;; Style to be applied to different syntax groups
               ;; Value is any valid attr-list value for `:help nvim_set_hl`
               :styles {:commnets  {:italic true}
                        :keywords  {:italic true}
                        :functions {:italic false}
                        :variables {:italic false}
                        ;; Background styles. Can be "dark", "transparent" or "normal"
                        ;; style for sidebars, see below
                        :sidebars :dark
                        ;; style for floating windows
                        :floats :dark}
               ;; Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
               :sidebars [:qf
                          :help
                          :toggleterm
                          :neo-tree]
               ;; Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
               :day_brightness 0.3
               ;; Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
               :hide_inactive_statusline false
               ;; dims inactive windows
               :dim_inactive false
               ;; When `true`, section headers in the lualine theme will be bold
               :lualine_bold false
               ;; You can override specific color groups to use other groups or a hex color
               ;; function will be called with a Highlights and ColorScheme table
               :on_colors (fn [colors])
               ;; You can override specific highlights to use other groups or a hex color
               ;; function will be called with a Highlights and ColorScheme table
               :on_highlights (fn [highlights colors]
                                (each [_ colour (ipairs ["Red" "Yellow" "Blue" "Orange" "Green" "Violet" "Cyan"])]
                                  (tset highlights
                                        (.. "RainbowDelimiter" colour)
                                        {:link (.. "TSRainbow" colour)})))}]
     (tokyonight.setup opt)
     (vim.cmd "colorscheme tokyonight")))

M
