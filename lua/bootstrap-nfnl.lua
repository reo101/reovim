-- [nfnl] fnl/bootstrap-nfnl.fnl
local nvim_config = vim.fn.stdpath("config")
local nvim_data = vim.fn.stdpath("data")
local nfnl_output_dir = (nvim_data .. "/nfnl")
local _local_1_ = require("fennel-loader")
local inject_custom_fennel = _local_1_["inject-custom-fennel"]
local typed_fennel_macro_path = _local_1_["typed-fennel-macro-path"]
local setup_fennel_paths = _local_1_["setup-fennel-paths"]
local inject_all_global_macros = _local_1_["inject-all-global-macros"]
inject_custom_fennel()
local function setup_paths()
  local nfnl_lua_dir = (nfnl_output_dir .. "/lua")
  local nfnl_after_dir = (nfnl_output_dir .. "/after")
  local config_lua_dir = (nvim_config .. "/lua")
  if not vim.tbl_contains(vim.opt.runtimepath:get(), nfnl_output_dir) then
    vim.opt.runtimepath:append(nfnl_output_dir)
  else
  end
  if ((1 == vim.fn.isdirectory(nfnl_after_dir)) and not vim.tbl_contains(vim.opt.runtimepath:get(), nfnl_after_dir)) then
    vim.opt.runtimepath:append(nfnl_after_dir)
  else
  end
  if not vim.tbl_contains(vim.opt.runtimepath:get(), config_lua_dir) then
    vim.opt.runtimepath:append(config_lua_dir)
  else
  end
  local config_path_pattern = (config_lua_dir .. "/?.lua;" .. config_lua_dir .. "/?/init.lua;")
  local nfnl_path_pattern = (nfnl_lua_dir .. "/?.lua;" .. nfnl_lua_dir .. "/?/init.lua;")
  package.path = package.path:gsub(vim.pesc(config_path_pattern), "")
  package.path = package.path:gsub(vim.pesc(nfnl_path_pattern), "")
  package.path = (config_path_pattern .. nfnl_path_pattern .. package.path)
  return nil
end
local bootstrap_files = {init = true, ["fnl/fennel-loader"] = true, ["fnl/bootstrap-nfnl"] = true, ["nix/lib/compile-fennel"] = true}
local function fnl_output_path(source_path)
  local relative_path = source_path:gsub(("^" .. vim.pesc(nvim_config) .. "/?"), "")
  local relative_path_no_ext = vim.fn.fnamemodify(relative_path, ":r")
  local lua_path = (relative_path_no_ext:gsub("^fnl/", "lua/") .. ".lua")
  local output_dir
  if bootstrap_files[relative_path_no_ext] then
    output_dir = nvim_config
  else
    output_dir = nfnl_output_dir
  end
  return (output_dir .. "/" .. lua_path)
end
local function newer_mtime_3f(source_mtime, output_mtime)
  return ((source_mtime.sec > output_mtime.sec) or ((source_mtime.sec == output_mtime.sec) and ((source_mtime.nsec or 0) > (output_mtime.nsec or 0))))
end
local function needs_compilation_3f()
  local sources = vim.fn.globpath(nvim_config, "**/*.fnl", false, true)
  table.insert(sources, (nvim_config .. "/init.fnl"))
  local stale_3f = false
  for _, source_path in ipairs(sources) do
    if not stale_3f then
      local source_stat = vim.uv.fs_stat(source_path)
      local output_stat = vim.uv.fs_stat(fnl_output_path(source_path))
      if (not output_stat or (source_stat and newer_mtime_3f(source_stat.mtime, output_stat.mtime))) then
        stale_3f = true
      else
      end
    else
    end
  end
  return stale_3f
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
  local function _9_(ev)
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
  return vim.api.nvim_create_autocmd("BufWritePost", {group = "nfnl_compile", pattern = "*.fnl", callback = _9_})
end
local function create_fnl_command()
  local fennel = require("fennel")
  local function _12_(opts)
    local code = opts.args
    local ok, result = pcall(fennel.eval, code, {compilerEnv = _G, allowedGlobals = false})
    if ok then
      return vim.print(fennel.view(result))
    else
      return vim.notify(tostring(result), vim.log.levels.ERROR)
    end
  end
  return vim.api.nvim_create_user_command("Fnl", _12_, {nargs = "+", desc = "Evaluate Fennel code using custom Fennel fork"})
end
local function create_nfnl_compile_command()
  local function _14_()
    compile_all_fennel()
    return vim.notify("nfnl: Compiled all Fennel files", vim.log.levels.INFO)
  end
  return vim.api.nvim_create_user_command("NfnlCompileAll", _14_, {desc = "Compile all Fennel files via nfnl"})
end
local function trust_nfnl_config()
  local nfnl_config_path = (nvim_config .. "/.nfnl.fnl")
  if (1 == vim.fn.filereadable(nfnl_config_path)) then
    local bufnr = vim.fn.bufadd(nfnl_config_path)
    local saved_ei = vim.o.eventignore
    vim.bo[bufnr]["swapfile"] = false
    vim.o.eventignore = "all"
    vim.fn.bufload(bufnr)
    vim.o.eventignore = saved_ei
    return pcall(vim.secure.trust, {bufnr = bufnr, action = "allow"})
  else
    return nil
  end
end
local function plugin_available_3f(name)
  local ok, _ = pcall(vim.cmd.packadd, {args = {name}})
  return ok
end
local function bootstrap_nfnl()
  trust_nfnl_config()
  if plugin_available_3f("nfnl") then
    local nfnl_path = (nvim_data .. "/site/pack/core/opt/nfnl")
    local nfnl_lua_path = (nfnl_path .. "/lua/?.lua")
    if (1 == vim.fn.isdirectory(nfnl_path)) then
      if not package.path:match(vim.pesc(nfnl_lua_path)) then
        package.path = (nfnl_lua_path .. ";" .. package.path)
        return nil
      else
        return nil
      end
    else
      return nil
    end
  else
    vim.pack.add({{src = "https://github.com/Olical/nfnl"}}, {confirm = false})
    local nfnl_path = (nvim_data .. "/site/pack/core/opt/nfnl")
    local nfnl_lua_path = (nfnl_path .. "/lua/?.lua")
    if not package.path:match(vim.pesc(nfnl_lua_path)) then
      package.path = (nfnl_lua_path .. ";" .. package.path)
      return nil
    else
      return nil
    end
  end
end
local function bootstrap_plugins()
  local function ensure_plugin(name, src, version)
    local ok, _ = pcall(vim.cmd.packadd, {args = {name}})
    if not ok then
      return vim.pack.add({{src = src, version = version}}, {confirm = false})
    else
      return nil
    end
  end
  ensure_plugin("lze", "https://github.com/BirdeeHub/lze", "v0.12.0")
  return ensure_plugin("typed-fennel", "https://github.com/reo101/typed-fennel", "subdirectories")
end
local nix_runtime_3f = (vim.g.nix_info_plugin_name ~= nil)
local function neovim_runtime_dir()
  local runtime_file = vim.api.nvim_get_runtime_file("lua/vim/treesitter/language.lua", false)[1]
  return ((runtime_file and runtime_file:gsub("/lua/vim/treesitter/language%.lua$", "")) or vim.env.VIMRUNTIME or vim.fn.expand("$VIMRUNTIME"))
end
local function neovim_parser_dir()
  local runtime_root = neovim_runtime_dir()
  if (runtime_root and (runtime_root ~= "")) then
    return vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(runtime_root))), "lib", "nvim", "parser")
  else
    return nil
  end
end
local function parser_entry_path(parser_dir, name)
  local path = vim.fs.joinpath(parser_dir, name)
  local stat = vim.uv.fs_stat(path)
  if (stat and (stat.type == "file")) then
    return path
  else
    return nil
  end
end
local function pin_neovim_parsers_early()
  local parser_dir = neovim_parser_dir()
  if parser_dir then
    for name, _ in vim.fs.dir(parser_dir) do
      local parser_path = parser_entry_path(parser_dir, name)
      local lang = (parser_path and name:match("^(.*)%.[^.]+$"))
      if (lang and (lang ~= "")) then
        vim.treesitter.language.add(lang, {path = parser_path})
      else
      end
    end
    return nil
  else
    return nil
  end
end
setup_paths()
pin_neovim_parsers_early()
bootstrap_nfnl()
bootstrap_plugins()
setup_fennel_paths(require("fennel"))
inject_all_global_macros(nvim_config)
create_fnl_command()
create_nfnl_compile_command()
if (needs_compilation_3f() and not nix_runtime_3f) then
  compile_all_fennel()
  setup_paths()
else
end
setup_fnl_autocommand()
local function _26_()
  local ft = vim.bo[vim.fn.bufnr()].filetype
  if (ft == "") then
    return vim.cmd("filetype detect")
  else
    return nil
  end
end
return vim.api.nvim_create_autocmd("VimEnter", {once = true, callback = _26_})
