local M = {}

-- Set the wiki directory path
M.wikidir = os.getenv("HOME") .. '/src/wiki'
-- Set the daily directory path
M.dailydir = M.wikidir .. '/daily'

-- List all files in the daily directory
function M.list_files()
    local files = {}
    local handle = vim.loop.fs_scandir(M.dailydir)
    if handle then
        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if type == "file" then
                table.insert(files, name)
            end
        end
    end
    return files
end

-- Print a greeting and list all files in the daily directory
function M.hello()
    print('yooo')
    local files = M.list_files()
    vim.notify(M.dailydir, vim.log.levels.INFO, { title = "dailydir " })
    vim.notify(table.concat(files, "\n"), vim.log.levels.INFO, { title = "File List" })
end

-- Open Telescope to find files in the wiki directory
function M.tele_wiki()
    require('telescope.builtin').find_files({
        prompt_title = "Select a File in Wiki Directory (" .. M.wikidir .. ")",
        cwd = M.wikidir,
    })
end

-- Open Telescope to find files in the daily directory
function M.tele_dailies()
    require('telescope.builtin').find_files({
        prompt_title = "Select a File in Daily Directory (" .. M.dailydir .. ")",
        cwd = M.dailydir,
    })
end

local function create_file_with_template(filename, template, subs)
    local template_file = io.open(template, "r")
    if not template_file then
        vim.notify("Template file not found: " .. template, vim.log.levels.ERROR)
        return
    end

    local template_content = template_file:read("*a")
    template_file:close()

    for _, subs in ipairs(subs) do
        local key, value = subs[1], subs[2]
        vim.notify('swapping ' .. key .. ' for ' .. value)
        template_content = template_content:gsub('{{ ' .. key .. ' }}', value)
    end

    local file = io.open(filename, "w")
    file:write(template_content)
    file:close()
end

-- Open or create a daily file with a specified offset in days
function M.open_daily(days_offset)
    days_offset = days_offset or 0
    local date = os.date("%Y-%m-%d", os.time() + days_offset * 86400)
    local filename = M.dailydir .. '/' .. date .. ".md"
    vim.notify('date is ' .. date)
    -- Check if the file exists
    local file = io.open(filename, "r")
    if file then
        vim.notify('File exists, opening it.')
        file:close()
    else
        vim.notify('creating file.')
        -- File doesn't exist, create it with the template content
        local template = os.getenv("HOME") .. '/.config/nvim/templates/daily.templ'
        local subs = {
            {"date", date}
        }
        create_file_with_template(filename, template, subs)
    end

    -- vim.cmd("aboveleft split " .. filename)  -- Open the file in the editor
   -- Open the file in the editor with 20% height or minimum 10 lines
    vim.cmd("aboveleft " .. math.max(10, math.floor(vim.o.lines * 0.2)) .. "split " .. filename)
    vim.b.womwiki = true  -- Tag the buffer as a womwiki buffer
    vim.cmd("lcd " .. vim.fn.fnameescape(M.wikidir))  -- Set wikidir just for that buffer
end

function M.close_daily()
    if vim.b.womwiki then
        vim.cmd('bd')  -- Close the buffer
    else
        print("Not a womwiki buffer")
    end
end

-- Define choices for the picker
local choices = {
    { "Today", function() M.open_daily() end },
    { "Close Daily", function() M.close_daily() end },
    { "Yesterday", function() M.open_daily(-1) end },
    { "Dailies", M.tele_dailies },
    { "Wikis", M.tele_wiki },
}

-- Display a picker with options
function M.picker()
    local options = { "womwiki" }
    for i, choice in ipairs(choices) do
        table.insert(options, string.format("%d: %s", i, choice[1]))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, options)

    local max_width = 0
    for _, line in ipairs(options) do
        if #line > max_width then
            max_width = #line
        end
    end

    local height = #options
    local win_width = math.min(max_width, vim.api.nvim_get_option("columns"))
    local win_height = math.min(height, vim.api.nvim_get_option("lines"))
    local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) / 2)
    local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = win_width,
        height = win_height,
        col = col,
        row = row,
        style = "minimal",
        border = "single",
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require("utils.womwiki").execute_selection(' .. buf .. ', ' .. win .. ')<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', { noremap = true, silent = true })

    for i = 1, #choices do
        vim.api.nvim_buf_set_keymap(buf, 'n', tostring(i), ':lua require("utils.womwiki").execute_selection(' .. buf .. ', ' .. win .. ', ' .. i .. ')<CR>', { noremap = true, silent = true })
    end
end

-- Execute the selected option from the picker
function M.execute_selection(buf, win, index)
    if not index then
        local line = vim.api.nvim_get_current_line()
        index = tonumber(line:match("^(%d):"))
    end
    if index then
        if choices[index] then
            vim.api.nvim_win_close(win, true)
            choices[index][2]()
        end
    end
end

return M

