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

return M
