(fn after []
  (let [tabout (require :tabout)
        opt {;; key to trigger tabout, set to an empty string to disable
             :tabkey :<Tab>
             ;; key to trigger backwards tabout, set to an empty string to disable
             :backwards_tabkey :<S-Tab>
             ;; shift content if tab out is not possible
             :act_as_tab true
             ;; reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
             :act_as_shift_tab true
             ;; well ...
             :enable_backwards true
             ;; if the tabkey is used in a completion pum
             :completion true
             :tabouts
               (let [tabouts
                      [["'" "'"]
                       ["\"" "\""]
                       ["`" "`"]
                       ["(" ")"]
                       ["[" "]"]
                       ["{" "}"]
                       ["<" ">"]
                       ["#" "]"]
                       ["#" ">"]]]
                 (icollect [_ [open close] (ipairs tabouts)]
                   {: open
                    : close}))
             ;; if the cursor is at the beginning of a filled element it will rather tab out than shift the content
             :ignore_beginning false
             ;; tabout will ignore these filetypes
             :exclude []}]
    (tabout.setup opt)))

{:src "https://github.com/abecodes/tabout.nvim"
 :data {:event :InsertEnter
        : after}}
