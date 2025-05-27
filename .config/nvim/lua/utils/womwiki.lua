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

function M.create_file_with_template(filename, template_path, subs)
  -- Ensure filename and template_path are absolute paths or handle them appropriately
  -- For testing, we will provide absolute paths.

  local file_exists_check = io.open(filename, "r")
  if file_exists_check then
    io.close(file_exists_check)
    vim.notify("File already exists: " .. filename, vim.log.levels.WARN, { title = "Womwiki" })
    return false
  end

  local template_file, err_template = io.open(template_path, "r")
  if not template_file then
    vim.notify("Template not found: " .. template_path .. (err_template and (" (" .. err_template .. ")") or ""), vim.log.levels.ERROR, { title = "Womwiki" })
    return false
  end

  local template_content = template_file:read("*a")
  io.close(template_file)

  local final_content = template_content
  if subs then
    for k, v in pairs(subs) do
      -- Using a slightly more robust gsub for keys that might contain special characters for patterns
      -- by escaping them. This assumes keys are simple strings.
      local escaped_key = string.gsub(k, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
      final_content = string.gsub(final_content, "${" .. escaped_key .. "}", tostring(v))
    end
  end

  local out_file, err_out = io.open(filename, "w")
  if not out_file then
    vim.notify("Failed to open file for writing: " .. filename .. (err_out and (" (" .. err_out .. ")") or ""), vim.log.levels.ERROR, { title = "Womwiki" })
    return false
  end

  local write_ok, err_write = out_file:write(final_content)
  if not write_ok then
    io.close(out_file) -- Close it even on write error
    vim.notify("Failed to write to file: " .. filename .. (err_write and (" (" .. err_write .. ")") or ""), vim.log.levels.ERROR, { title = "Womwiki" })
    return false
  end
  
  io.close(out_file)
  vim.notify("File created: " .. filename, vim.log.levels.INFO, { title = "Womwiki" })
  return true
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
        local template_path = os.getenv("HOME") .. '/.config/nvim/templates/daily.templ'
        local subs = {
            date = date -- Changed to a key-value map
        }
        -- Call the updated function, which now belongs to M
        M.create_file_with_template(filename, template_path, subs)
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
function M.picker(current_choices)
    local options = { "womwiki" }
    for i, choice_item in ipairs(current_choices) do
        table.insert(options, string.format("%d: %s", i, choice_item[1]))
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

    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require("utils.womwiki").execute_selection(' .. buf .. ', ' .. win .. ', nil, require("utils.womwiki").get_choices())<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-c>', ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', { noremap = true, silent = true })

    for i = 1, #current_choices do
        vim.api.nvim_buf_set_keymap(buf, 'n', tostring(i), ':lua require("utils.womwiki").execute_selection(' .. buf .. ', ' .. win .. ', ' .. i .. ', require("utils.womwiki").get_choices())<CR>', { noremap = true, silent = true })
    end
end

-- Getter for the module-level choices, needed for keymaps in picker
function M.get_choices()
    return choices
end

-- Execute the selected option from the picker
function M.execute_selection(buf, win, index, choices_to_execute_from)
    local C = choices_to_execute_from or choices -- Use provided choices or fallback to module-level

    if not index then
        -- Get the current line content from the picker buffer
        local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
        local line_content = vim.api.nvim_buf_get_lines(buf, cursor_row - 1, cursor_row, false)[1]
        
        if line_content then
            index = tonumber(line_content:match("^(%d):"))
        end
    end

    if index and C[index] and type(C[index][2]) == "function" then
        vim.api.nvim_win_close(win, true)
        C[index][2]() -- Execute the function from the determined choices table
    else
        vim.notify("Invalid selection or action for index: " .. tostring(index), vim.log.levels.WARN, { title = "Womwiki Picker" })
    end
end

return M

