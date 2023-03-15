(fn config []
  (let [opt {:filetypes
              {:css {:RGB      true ;; #RGB hex codes
                     :RRGGBB   true ;; #RRGGBB hex codes
                     :names    true ;; Name codes like Blue
                     :RRGGBBAA true ;; #RRGGBBAA hex codes
                     :AARRGGBB true ;; 0xAARRGGBB hex codes
                     :rgb_fn   true ;; CSS rgb and rgba functions
                     :hsl_fn   true ;; CSS hsl and hsla functions
                     :css      true ;; Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                     :css_fn   true ;; Enable all CSS *functions*: rgb_fn, hsl_fn
                     ;; Available modes: foreground, background, virtualtext
                     :mode        "background" ;; Set the display mode.
                     :virtualtext "■"}         ;; Set the virtualtext text 
               :html {:mode "foreground"}
               1 :javascript}
             :user_default_options {:mode "background"}}]
    ((. (require "colorizer") :setup) opt)))

{: config}
