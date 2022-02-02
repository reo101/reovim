local M = {}

M.config = function()

    local opt = {
        engines = {
            xelatex = {
                executable = "latexmk",
                args = {
                    "-xelatex",
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-pvc",
                    "%f"
                },
                isContinuous = false,
                onSave = true,
            },
            pdflatex = { -- This has the same name as a default engine but would
                         -- be preferred over the same-name default if defined
                executable = "latexmk",
                args = {
                    "-pdflatex",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-outdir=.build",
                    "-pv",
                    "%f"
                },
                isContinuous = false,
            },
            lualatex = { -- This is *not* one of the defaults, but it can be
                         -- called via magic comment if defined here
                executable = "latexmk",
                args = {
                    "-pdflua",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-pv",
                    "%f"
                },
                isContinuous = false,
            }
        }
    }

    require("texmagic").setup(opt)

end

return M
