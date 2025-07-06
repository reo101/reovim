-- [nfnl] fnl/bootstrap-nfnl.fnl
local nvim_config = vim.fn.stdpath("config")
local nvim_data = vim.fn.stdpath("data")
local nfnl_output_dir = (nvim_data .. "/nfnl")
local _local_1_ = require("fennel-loader")
local inject_custom_fennel = _local_1_["inject-custom-fennel"]
local typed_fennel_macro_path = _local_1_["typed-fennel-macro-path"]
local setup_fennel_paths = _local_1_["setup-fennel-paths"]
inject_custom_fennel()
setup_fennel_paths(require("fennel"))
local function setup_paths()
  local nfnl_lua_dir = (nfnl_output_dir .. "/lua")
  if not vim.tbl_contains(vim.opt.runtimepath:get(), nfnl_output_dir) then
    vim.opt.runtimepath:append(nfnl_output_dir)
  else
  end
  local lua_path_pattern = (nfnl_lua_dir .. "/?.lua;" .. nfnl_lua_dir .. "/?/init.lua;")
  package.path = (lua_path_pattern .. package.path:gsub(vim.pesc(lua_path_pattern), ""))
  return nil
end
local function needs_initial_compilation_3f()
  local nfnl_lua_dir = (nfnl_output_dir .. "/lua")
  return (1 ~= vim.fn.isdirectory(nfnl_lua_dir))
end
local function compile_all_fennel()
  local ok, nfnl_api = pcall(require, "nfnl.api")
  if ok then
    return nfnl_api["compile-all-files"](nvim_config)
  else
    return nil
  end
end
local function setup_fnl_autocommand()
  vim.api.nvim_create_augroup("nfnl_compile", {clear = true})
  local function _4_(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    local dir = vim.fn.fnamemodify(path, ":h")
    local ok, nfnl_api = pcall(require, "nfnl.api")
    if not ok then
      vim.notify(("nfnl: Failed to load nfnl.api: " .. tostring(nfnl_api)), vim.log.levels.WARN)
      return nil
    else
    end
    local ok0, result = pcall(nfnl_api["compile-file"], {path = path, dir = dir})
    if not ok0 then
      vim.notify(("nfnl: Compilation error: " .. tostring(result)), vim.log.levels.ERROR)
      return nil
    else
    end
    return nil
  end
  return vim.api.nvim_create_autocmd("BufWritePost", {group = "nfnl_compile", pattern = "*.fnl", callback = _4_})
end
local function create_fnl_command()
  local fennel = require("fennel")
  local function _7_(opts)
    local code = opts.args
    local ok, result = pcall(fennel.eval, code, {env = "_COMPILER"})
    if ok then
      return vim.print(fennel.view(result))
    else
      return vim.notify(tostring(result), vim.log.levels.ERROR)
    end
  end
  return vim.api.nvim_create_user_command("Fnl", _7_, {nargs = "+", desc = "Evaluate Fennel code using custom Fennel fork"})
end
local function create_nfnl_compile_command()
  local function _9_()
    compile_all_fennel()
    return vim.notify("nfnl: Compiled all Fennel files", vim.log.levels.INFO)
  end
  return vim.api.nvim_create_user_command("NfnlCompileAll", _9_, {desc = "Compile all Fennel files via nfnl"})
end
local function trust_nfnl_config()
  local nfnl_config_path = (nvim_config .. "/.nfnl.fnl")
  if (1 == vim.fn.filereadable(nfnl_config_path)) then
    local bufnr = vim.fn.bufadd(nfnl_config_path)
    vim.bo[bufnr]["swapfile"] = false
    vim.fn.bufload(bufnr)
    return pcall(vim.secure.trust, {bufnr = bufnr, action = "allow"})
  else
    return nil
  end
end
local function bootstrap_nfnl()
  trust_nfnl_config()
  local nfnl_path = (nvim_data .. "/site/pack/core/opt/nfnl")
  local nfnl_lua_path = (nfnl_path .. "/lua/?.lua")
  if (1 == vim.fn.isdirectory(nfnl_path)) then
    vim.cmd.packadd({args = {"nfnl"}})
  else
    vim.pack.add({{src = "https://github.com/Olical/nfnl"}}, {confirm = false})
  end
  if not package.path:match(vim.pesc(nfnl_lua_path)) then
    package.path = (nfnl_lua_path .. ";" .. package.path)
    return nil
  else
    return nil
  end
end
local function bootstrap_plugins()
  local function ensure_plugin(name, src, version)
    local plugin_path = (nvim_data .. "/site/pack/core/opt/" .. name)
    if (1 == vim.fn.isdirectory(plugin_path)) then
      return vim.cmd.packadd({args = {name}})
    else
      return vim.pack.add({{src = src, version = version}}, {confirm = false})
    end
  end
  ensure_plugin("lze", "https://github.com/BirdeeHub/lze", "v0.12.0")
  return ensure_plugin("typed-fennel", "https://github.com/reo101/typed-fennel", "subdirectories")
end
setup_paths()
create_fnl_command()
create_nfnl_compile_command()
bootstrap_nfnl()
bootstrap_plugins()
if needs_initial_compilation_3f() then
  compile_all_fennel()
  setup_paths()
else
end
return setup_fnl_autocommand()
