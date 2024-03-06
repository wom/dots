-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

-- We have to set the leader key here for lazy.nvim to work
require("utils.keys").set_leader(" ")

-- Load plugins from specifications
-- (The leader key must be set before this)
lazy.setup("plugins")

-- Might as well set up an easy-access keybinding

require("utils.keys").map("n", "<leader>L", lazy.show, "Show Lazy")
function NumberToggle()
    if vim.wo.relativenumber == true then
        vim.wo.relativenumber = false
        vim.wo.foldcolumn = 0
    else
        if vim.wo.number == true then
            vim.wo.number = false
            vim.wo.relativenumber = true
        else
            vim.wo.number = true
        end
    end
end

vim.api.nvim_set_keymap('n', '<F2>', ':lua NumberToggle()<CR>', { noremap = true, silent = true })

