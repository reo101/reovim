---Install essential plugins without a package manager
---@param user string
---@param repo string
---@param additional_cmd fun(install_path: string)
local function ensure(user, repo, additional_cmd)
    local install_path = string.format(
        "%s/packer/start/%s",
        vim.fn.stdpath("data") .. "/site/pack",
        repo
    )
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        print(
            string.format(
                "Could not find %s, cloning new copy to %s",
                repo,
                install_path
            )
        )
        vim.fn.system({
            "git",
            "clone",
            string.format(
                "https://www.github.com/%s/%s %s",
                user,
                repo,
                install_path
            ),
        })
        vim.cmd(string.format("packadd %s", repo))
        if additional_cmd then
            additional_cmd(install_path)
        end
    end
end

-- Packer
ensure("wbthomason", "packer.nvim", function()
    vim.cmd("packadd vimball")
end)

-- HotPot
ensure("rktjmp", "hotpot.nvim", function(hotpot_path)
    vim.cmd("helptags " .. hotpot_path .. "/doc")
end)

require("hotpot")
