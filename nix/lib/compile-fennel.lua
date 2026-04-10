-- [nfnl] nix/lib/compile-fennel.fnl
do
  local nfnl_path = os.getenv("NFNL_PATH")
  if nfnl_path then
    package.path = (nfnl_path .. "/lua/?.lua;" .. package.path)
  else
  end
end
do
  local build_packpath = os.getenv("REOVIM_BUILD_PACKPATH")
  if build_packpath then
    vim.opt.packpath:append(build_packpath)
  else
  end
end
do
  local nfnl_config_path = (vim.fn.getcwd() .. "/.nfnl.fnl")
  if (vim.fn.filereadable(nfnl_config_path) == 1) then
    local bufnr = vim.fn.bufadd(nfnl_config_path)
    vim.bo[bufnr]["swapfile"] = false
    vim.fn.bufload(bufnr)
    pcall(vim.secure.trust, {bufnr = bufnr, action = "allow"})
  else
  end
end
local nfnl_api = require("nfnl.api")
local results = nfnl_api["compile-all-files"](".")
do
  local result_file = io.open("/tmp/nfnl-compile-results.lua", "w")
  if result_file then
    result_file:write(vim.inspect(results))
    result_file:close()
  else
  end
end
local error_count = 0
local total_count = 0
if (type(results) == "table") then
  for k, v in pairs(results) do
    total_count = (total_count + 1)
    if (v.ok == false) then
      error_count = (error_count + 1)
      print(("ERROR: Failed to compile " .. tostring(k) .. ": " .. tostring((v.err or "unknown error"))))
    else
    end
  end
else
end
print(("FENNEL_COMPILE_INFO: " .. total_count .. " file(s) processed, " .. error_count .. " error(s)"))
if (error_count > 0) then
  print("FENNEL_COMPILE_FAILED: Build aborted due to compilation errors")
  vim.cmd("cq")
  return os.exit(1)
else
  return print("FENNEL_COMPILE_SUCCESS: All files compiled successfully")
end
