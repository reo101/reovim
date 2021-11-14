--       ___           ___           ___     
--      /  /\         /  /\         /  /\    
--     /  /::\       /  /:/_       /  /::\   
--    /  /:/\:\     /  /:/ /\     /  /:/\:\  
--   /  /:/~/:/    /  /:/ /:/_   /  /:/  \:\ 
--  /__/:/ /:/___ /__/:/ /:/ /\ /__/:/ \__\:\
--  \  \:\/:::::/ \  \:\/:/ /:/ \  \:\ /  /:/
--   \  \::/~~~~   \  \::/ /:/   \  \:\  /:/ 
--    \  \:\        \  \:\/:/     \  \:\/:/  
--     \  \:\        \  \::/       \  \::/   
--      \__\/         \__\/         \__\/    
--                                ___     
--       ___        ___          /__/\    
--      /__/\      /  /\        |  |::\   
--      \  \:\    /  /:/        |  |:|:\  
--       \  \:\  /__/::\      __|__|:|\:\ 
--   ___  \__\:\ \__\/\:\__  /__/::::| \:\
--  /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
--  \  \:\|  |:|     \__\::/  \  \:\      
--   \  \:\__|:|     /__/:/    \  \:\     
--    \__\::::/      \__\/      \  \:\    
--        ~~~~                   \__\/    

require("settings")

local function prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    return nil
end

if prequire("impatient") then
    prequire("impatient").enable_profile()
    prequire("packer_compiled")
end

require("plugins")

require("rv-autocommands")
