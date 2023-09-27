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

function M.isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        -- loaders renamed searchers in lua 5.3
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == "function" then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

function M.join_paths(...)
    local result = table.concat({ ... }, vim.loop.os_uname().version:match("Windows") and "\\" or "/")
    return result
end

function M.get_config_dir()
    local nvim_config_dir = M.join_paths(M.join_paths(os.getenv("HOME"), ".config"), "nvim")
    if not nvim_config_dir then
        return vim.call("stdpath", "config")
    end
    return nvim_config_dir
end

function M.get_snapshot_dir()
    local nvim_snapshot_dir = M.join_paths(M.get_config_dir(), "snapshot")
    return nvim_snapshot_dir
end

return M
