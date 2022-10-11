local Settings = {}
Settings.load_settings = function()
    -- vim.cmd('colorscheme duskfox') -- How to do via lua?
    vim.cmd('colorscheme catppuccin') -- How to do via lua?
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.opt.showcmd = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.guifont = "FiraCode NF:h8"
    vim.opt.termguicolors = true
    vim.opt.timeoutlen = 250
    vim.opt.mouse = "a"
    vim.opt.history = 1000

end

return Settings
