(fn config []
  (let [hologram (require :hologram)
        config {:auto_display true}]
    (hologram.setup config)))

{: config}
