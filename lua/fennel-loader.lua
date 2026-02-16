-- [nfnl] fnl/fennel-loader.fnl
local dev_fennel_path = (vim.env.HOME .. "/Projects/Home/Fennel/Fennel")
local specials_registry = {}
local macro_registry = {}
local fennel_module_prefixes = {"fennel", "nfnl.fennel", "conjure.aniseed.deps.fennel", "conjure.aniseed.fennel", "conjure.nfnl.fennel"}
local fennel_submodules = {"compiler", "parser", "specials", "utils", "view", "repl", "friend", "binary"}
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
local function fennel_module_key_3f(k)
  if (type(k) == "string") then
    local match_3f = false
    for _, prefix in ipairs(fennel_module_prefixes) do
      match_3f = (match_3f or (k == prefix) or vim.startswith(k, (prefix .. ".")))
    end
    return match_3f
  else
    return nil
  end
end
local function sync_fennel_submodules_21(prefix)
  for _, sub in ipairs(fennel_submodules) do
    local standard_key = ("fennel." .. sub)
    local target_key = (prefix .. "." .. sub)
    local mod = package.loaded[standard_key]
    if mod then
      package.loaded[target_key] = mod
    else
    end
  end
  return nil
end
local function purge_fennel_modules()
  for _, tbl in ipairs({"loaded", "preload"}) do
    for k, _0 in pairs(package[tbl]) do
      if fennel_module_key_3f(k) then
        package[tbl][k] = nil
      else
      end
    end
  end
  return nil
end
local function sync_fennel_modules(fennel)
  local f = (fennel or package.loaded.fennel)
  if (f and (type(f) == "table")) then
    for _, sub in ipairs(fennel_submodules) do
      pcall(require, ("fennel." .. sub))
    end
    for _, prefix in ipairs(fennel_module_prefixes) do
      package.loaded[prefix] = f
      sync_fennel_submodules_21(prefix)
    end
    return nil
  else
    return nil
  end
end
local function patch_table(t, registry)
  if ((type(t) == "table") and (type(registry) == "table")) then
    for name, target in pairs(registry) do
      local val = (t[target] or target)
      if (val and not t[name]) then
        t[name] = val
      else
      end
    end
    return true
  else
    return nil
  end
end
local function patch_scope(scope)
  if (type(scope) == "table") then
    local _16_
    do
      local t_15_ = scope
      if (nil ~= t_15_) then
        t_15_ = t_15_.specials
      else
      end
      _16_ = t_15_
    end
    patch_table(_16_, specials_registry)
    local _19_
    do
      local t_18_ = scope
      if (nil ~= t_18_) then
        t_18_ = t_18_.macros
      else
      end
      _19_ = t_18_
    end
    patch_table(_19_, macro_registry)
    return scope
  else
    return nil
  end
end
local function patch_specials_module()
  local ok, specials = pcall(require, "fennel.specials")
  if (ok and (type(specials) == "table")) then
    return patch_table(specials, specials_registry)
  else
    return nil
  end
end
local function apply_registries()
  do
    local ok_compiler, compiler = pcall(require, "fennel.compiler")
    if ok_compiler then
      local function _24_()
        local t_23_ = compiler
        if (nil ~= t_23_) then
          t_23_ = t_23_.scopes
        else
        end
        if (nil ~= t_23_) then
          t_23_ = t_23_.global
        else
        end
        return t_23_
      end
      patch_scope(_24_())
      local function _28_()
        local t_27_ = compiler
        if (nil ~= t_27_) then
          t_27_ = t_27_.scopes
        else
        end
        if (nil ~= t_27_) then
          t_27_ = t_27_.compiler
        else
        end
        return t_27_
      end
      patch_scope(_28_())
    else
    end
  end
  return patch_specials_module()
end
local function merge_registry_21(registry, defs)
  if (type(defs) == "table") then
    for name, value in pairs(defs) do
      local _32_
      if ((type(value) == "table") and (value.clone ~= nil)) then
        _32_ = (value.value or value.clone)
      else
        _32_ = value
      end
      registry[name] = _32_
    end
    return nil
  else
    return nil
  end
end
local function registry_snapshot(registry)
  local copy = {}
  for name, value in pairs((registry or {})) do
    copy[name] = value
  end
  return copy
end
local function register_macro_defs(defs)
  merge_registry_21(specials_registry, defs.specials)
  merge_registry_21(macro_registry, defs.macros)
  return apply_registries()
end
local function registered_defs()
  return {specials = registry_snapshot(specials_registry), macros = registry_snapshot(macro_registry)}
end
local function nfnl_output_lua_path()
  local nfnl_lua_dir = (vim.fn.stdpath("data") .. "/nfnl/lua")
  return (nfnl_lua_dir .. "/?.lua;" .. nfnl_lua_dir .. "/?/init.lua")
end
local function prepend_package_path_21(path_prefix)
  if not package.path:match(vim.pesc(path_prefix)) then
    package.path = (path_prefix .. ";" .. package.path)
    return nil
  else
    return nil
  end
end
local function maybe_packadd_21(plugin_name)
  return pcall(vim.cmd.packadd, {args = {plugin_name}})
end
local function runtime_file(plugin_name, file_name)
  maybe_packadd_21(plugin_name)
  local candidates = vim.api.nvim_get_runtime_file(file_name, true)
  local preferred_pattern = ("/" .. vim.pesc(plugin_name) .. "/" .. vim.pesc(file_name) .. "$")
  local _36_
  do
    local found_path = nil
    for _, path in ipairs(candidates) do
      found_path = (found_path or (path:match(preferred_pattern) and path))
    end
    _36_ = found_path
  end
  return (_36_ or candidates[1])
end
local function register_macros_from_module(module_name)
  package.loaded[module_name] = nil
  local ok, defs = pcall(require, module_name)
  if ok then
    return register_macro_defs(defs)
  else
    return vim.notify(("fennel-loader: Failed to load macros from module " .. module_name .. ": " .. tostring(defs)), vim.log.levels.WARN)
  end
end
local function inject_all_global_macros()
  prepend_package_path_21(nfnl_output_lua_path())
  for _, module_name in ipairs({"macros.init", "macros.jp"}) do
    package.loaded[module_name] = nil
  end
  return register_macros_from_module("macros.init")
end
local function typed_fennel_plugin_parent()
  local init_macros_path = runtime_file("typed-fennel", "init-macros.fnl")
  if init_macros_path then
    return vim.fs.dirname(vim.fs.dirname(init_macros_path))
  else
    return nil
  end
end
local function typed_fennel_path()
  local plugin_parent = typed_fennel_plugin_parent()
  if plugin_parent then
    return (plugin_parent .. "/?/init.fnl")
  else
    return nil
  end
end
local function typed_fennel_macro_path()
  local plugin_parent = typed_fennel_plugin_parent()
  if plugin_parent then
    return (plugin_parent .. "/?/init-macros.fnl")
  else
    return nil
  end
end
local function config_fennel_path(config_dir)
  return (config_dir .. "/?.fnl;" .. config_dir .. "/?/init.fnl;" .. config_dir .. "/fnl/?.fnl;" .. config_dir .. "/fnl/?/init.fnl")
end
local function prepend_search_path_21(fennel, key, path_prefix)
  local current = fennel[key]
  if ((type(current) == "string") and not current:match(vim.pesc(path_prefix))) then
    fennel[key] = (path_prefix .. ";" .. current)
    return nil
  else
    return nil
  end
end
local function setup_fennel_paths(fennel, _3fconfig_dir)
  local config_dir = (_3fconfig_dir or vim.fn.stdpath("config"))
  if (type(fennel) == "table") then
    prepend_search_path_21(fennel, "path", config_fennel_path(config_dir))
    do
      local typed_fennel_path0 = typed_fennel_path()
      if typed_fennel_path0 then
        prepend_search_path_21(fennel, "path", typed_fennel_path0)
      else
      end
    end
    local macro_path = typed_fennel_macro_path()
    if macro_path then
      return prepend_search_path_21(fennel, "macro-path", macro_path)
    else
      return nil
    end
  else
    return nil
  end
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
  sync_fennel_modules(fennel)
  apply_registries()
  return fennel
end
return {["sync-fennel-modules"] = sync_fennel_modules, ["inject-custom-fennel"] = inject_custom_fennel, ["inject-all-global-macros"] = inject_all_global_macros, ["registered-defs"] = registered_defs, ["typed-fennel-macro-path"] = typed_fennel_macro_path, ["setup-fennel-paths"] = setup_fennel_paths}
