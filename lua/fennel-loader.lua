-- [nfnl] fnl/fennel-loader.fnl
local dev_fennel_path = (vim.env.HOME .. "/Projects/Home/Fennel/Fennel")
local function find_nix_fennel_path()
  local fennel_bin = vim.fn.exepath("fennel")
  if (fennel_bin and (fennel_bin ~= "")) then
    local resolved = vim.fn.resolve(fennel_bin)
    local store_path = resolved:match("^(.*/[^/]+)/bin/fennel$")
    if store_path then
      local lua_path = (store_path .. "/share/lua/5.1")
      if (1 == vim.fn.isdirectory(lua_path)) then
        return lua_path
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function has_discard_support_3f(fennel_path)
  local test_path = (fennel_path .. "/?.lua")
  local saved_path = package.path
  package.path = (test_path .. ";" .. package.path)
  local ok, fennel = pcall(require, "fennel")
  package.path = saved_path
  if ok then
    for k, _ in pairs(package.loaded) do
      if k:match("^fennel%.?") then
        package.loaded[k] = nil
      else
      end
    end
  else
  end
  if ok then
    local eval_ok, result = pcall(fennel.eval, "(+ 1 #_2 3)")
    return (eval_ok and (result == 4))
  else
    return nil
  end
end
local function find_custom_fennel()
  if ((1 == vim.fn.isdirectory(dev_fennel_path)) and has_discard_support_3f(dev_fennel_path)) then
    return dev_fennel_path
  else
    local nix_path = find_nix_fennel_path()
    if (nix_path and has_discard_support_3f(nix_path)) then
      return nix_path
    else
      return nil
    end
  end
end
local function purge_fennel_modules()
  for _, tbl in ipairs({"loaded", "preload"}) do
    for k, _0 in pairs(package[tbl]) do
      if (k:match("^fennel%.") or k:match("^nfnl%.fennel")) then
        package[tbl][k] = nil
      else
      end
    end
  end
  return nil
end
local function inject_custom_fennel()
  local fennel_path = find_custom_fennel()
  if not fennel_path then
    error(("Custom Fennel with #_ support not found.\n" .. "Checked: " .. dev_fennel_path .. "\n" .. "Also checked PATH for Nix-built fennel."))
  else
  end
  purge_fennel_modules()
  if not package.path:match(vim.pesc(fennel_path)) then
    package.path = (fennel_path .. "/?.lua;" .. package.path)
  else
  end
  local fennel = require("fennel")
  package.loaded["nfnl.fennel"] = fennel
  return fennel
end
return {["dev-fennel-path"] = dev_fennel_path, ["find-nix-fennel-path"] = find_nix_fennel_path, ["has-discard-support?"] = has_discard_support_3f, ["find-custom-fennel"] = find_custom_fennel, ["purge-fennel-modules"] = purge_fennel_modules, ["inject-custom-fennel"] = inject_custom_fennel}
