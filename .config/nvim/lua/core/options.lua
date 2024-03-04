local opts = {
    shiftwidth = 4,
    tabstop = 4,
    expandtab = true,
    wrap = false,
    termguicolors = true,
    number = true,
    relativenumber = true,
    foldmethod = 'indent',
    foldlevelstart=99,
}

-- Set options from table
for opt, val in pairs(opts) do
    vim.o[opt] = val
end

-- Set other options
local colorscheme = require("utils.colorscheme")
vim.cmd.colorscheme(colorscheme)
