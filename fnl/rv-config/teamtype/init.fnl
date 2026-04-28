(fn after []
  (let [teamtype (require :teamtype)
        dk (require :def-keymaps)]

    (dk :n
        {:y {:group :TeamType
             :i [#(vim.cmd.TeamtypeInfo) :Info]
             :j [#(vim.cmd.TeamtypeJumpToCursor) :JumpToCursor]
             :f [#(vim.cmd.TeamtypeFollow) :Follow]}}
        {:prefix :<leader>})))

{:src "https://github.com/teamtype/teamtype-nvim"
 :data {: after}}
