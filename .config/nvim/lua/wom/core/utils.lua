
-- Probably return functions here to be used elsewhere?
local function getPopups()
    return vim.fn.filter(vim.api.nvim_tabpage_list_wins(0),
        function(_, e) return vim.api.nvim_win_get_config(e).zindex end)
end

local function killPopups()
   vim.fn.map(getPopups(), function(_, e)
        vim.api.nvim_win_close(e, false)
    end)
end

local keymap = vim.keymap
keymap.set("n", "<esc>", function()
    vim.cmd.noh()
    killPopups()
end)

-- visually select pasted content
keymap.set("n", "gp", function()
    return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, {expr=true})

-- visually select pasted content
vim.keymap.set("n", "gp", function()
    return "`[" .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. "`]"
end, {expr=true})
