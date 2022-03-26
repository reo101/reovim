----------------------
-- Global Functions --
----------------------

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


----------------------
-- Helper Functions --
----------------------
local M = {}

-- Safe require
M.prequire = function(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

-- Table with all high-level configuration options
M.custom = {
    ---@type '"fidget"'|'"notify"'
    ["lsp_progress"] = "fidget",

    ---@type boolean
    ["lua_index_plugins"] = false,
}

return M
