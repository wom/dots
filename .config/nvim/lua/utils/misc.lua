local M = {}
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

function M.current_date()
    local date = os.date('%Y-%m-%d')
    vim.api.nvim_put({ date }, 'c', true, true)
end


function M.SysYank()
    -- local cb = 'xsel -bi' -- set to ur clipboard
    local cb = 'clip.exe' -- set to ur clipboard
    local typ = 'visual'
    local cbcn = vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true)
    local cv = vim.api.nvim_replace_termcodes('<C-v>', true, true, true)
    local tmap = { line = 'V', char = 'v', block = cv }
    vim.api.nvim_feedkeys(cbcn, 'x', false) -- flushes visualmode()
    local p1 = vim.fn.getpos(typ == 'visual' and "'<" or "'[")
    local p2 = vim.fn.getpos(typ == 'visual' and "'>" or "']")
    local t  = { type = (typ == 'visual' and vim.fn.visualmode() or tmap[typ]) }
    local r  = table.concat(vim.fn.getregion(p1, p2, t), '\n')
    vim.fn.system(cb, r)
end

return M
