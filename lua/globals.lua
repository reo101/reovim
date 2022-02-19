-- Global Functions

-- General print using inspect
P = function(v)
  print(vim.inspect(v))
  return v
end

-- Print table values
PP = function(...)
  local vars = vim.tbl_map(vim.inspect, { ... })
  print(unpack(vars))
end

-- Helper function for quick reloading a lua module and optionally its subpackages
R = function(name, all_submodules)
  local reload = require("plenary.reload").reload_module
  reload(name, all_submodules)
end
