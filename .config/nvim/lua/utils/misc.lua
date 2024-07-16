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

function M.Get_Visual()
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  return vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
end

-- Function to copy text to system clipboard. Move to utils?
function M.Copy_To_Clipboard(text)
    local found = ''
    local hasClip = os.execute("which clip.exe >nul 2>&1")
    if hasClip == 0 or hasClip == true then
        os.execute("echo " .. text .. " | clip.exe")
        found = "clip.exe"
    elseif os.execute("command -v xclip > /dev/null 2>&1") == 0 then
        os.execute("echo '" .. text .. "' | xclip -selection clipboard")
        found = "xclip"
    elseif os.execute("command -v pbcopy > /dev/null 2>&1") == 0 then
        os.execute("echo '" .. text .. "' | pbcopy")
        found = "pbcopy"
    end
    if found == '' then
        vim.notify('Unable to find clipboard passthrough.')
        return false
    else
        vim.notify('Copied via ' .. found .. '.')
        return true
    end
end

return M
