local M = {}
-- Misc functions we can use <everywhere>
--

-- Toggle the quickfix window
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
