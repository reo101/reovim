(let [heirline   (require :heirline)
      conditions (require :heirline.conditions)
      utils      (require :heirline.utils)
      colors     {:red    (. (utils.get_highlight :DiagnosticError) :fg)
                  :green  (. (utils.get_highlight :String)          :fg)
                  :blue   (. (utils.get_highlight :Function)        :fg)
                  :gray   (. (utils.get_highlight :NonText)         :fg)
                  :orange (. (utils.get_highlight :DiagnosticWarn)  :fg)
                  :yellow (. (utils.get_highlight :Todo)            :fg)
                  :purple (. (utils.get_highlight :Statement)       :fg)
                  :cyan   (. (utils.get_highlight :Special)         :fg)
                  :diag   {:warn  (. (utils.get_highlight :DiagnosticWarn)  :fg)
                           :error (. (utils.get_highlight :DiagnosticError) :fg)
                           :hint  (. (utils.get_highlight :DiagnosticHint)  :fg)
                           :info  (. (utils.get_highlight :DiagnosticInfo)  :fg)}
                  :git    {:del    (. (utils.get_highlight :DiffDelete) :fg)
                           :add    (. (utils.get_highlight :DiffAdd)   :fg)
                           :change (. (utils.get_highlight :DiffChange) :fg)}}
      heirline-components (require :heirline-components.all)
      navic   (require :nvim-navic)
      luasnip (require :luasnip)
      ;; neogit  (require :neogit)
      dap     (require :dap)
      icons   (require :nvim-web-devicons)]
  {: heirline
   : conditions
   : utils
   : colors
   : heirline-components
   : navic
   : luasnip
   : dap
   : icons})
