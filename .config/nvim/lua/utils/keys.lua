local M = {}

M.map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

M.lsp_map = function(lhs, rhs, bufnr, desc)
	vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

M.dap_map = function(mode, lhs, rhs, desc)
	M.map(mode, lhs, rhs, desc)
end

M.set_leader = function(key)
	vim.g.mapleader = key
	vim.g.maplocalleader = key
	M.map({ "n", "v" }, key, "<nop>")
end

function M.toggle_quickfix()
    local windows = vim.fn.getwininfo()
    local quickfix_open = false

    for _, value in pairs(windows) do
        if value["quickfix"] == 1 then
            quickfix_open = true
        end
    end

    if quickfix_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

return M
