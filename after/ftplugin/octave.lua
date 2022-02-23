local Terminal = require("toggleterm.terminal").Terminal

local octave = Terminal:new({
    cmd = "octave -qf",
    close_on_exit = true,
    hidden = true,
    on_open = function()
        vim.notify("Octave opened")
    end,
    on_close = function()
        vim.notify("Octave closed")
    end,
    -- on_open = fun(t: Terminal) -- function to run when the terminal opens
    -- on_close = fun(t: Terminal) -- function to run when the terminal closes
    -- -- callbacks for processing the output
    -- on_stdout = fun(job: number, exit_code: number, type: string)
    -- on_stderr = fun(job: number, data: string[], name: string)
    -- on_exit = fun(job: number, data: string[], name: string)
})

local wk = require("which-key")

local mappings = {
    t = {
        name = "Toggle",
        o = { function() octave:toggle() end, "Octave" },
    },
}

wk.register(mappings, { prefix = "<leader>" })
