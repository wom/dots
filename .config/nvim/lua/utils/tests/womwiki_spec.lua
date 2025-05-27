local Path = require('plenary.path')
local test_utils = require('plenary.test_utils')

-- Assuming your womwiki module is located at 'utils.womwiki'
-- Adjust this require path if necessary.
local womwiki = require('utils.womwiki')

describe('womwiki.list_files()', function()
  local original_dailydir
  local temp_dir_path

  before_each(function()
    -- Save the original M.dailydir
    original_dailydir = womwiki.dailydir

    -- Create a new temporary directory for each test
    -- plenary.path.new makes a unique temp directory name
    temp_dir_path = Path:new(os.tmpname()):with_extension('') -- Ensure it's a directory-like name
    temp_dir_path:mkdir({ parents = true }) -- Create the directory

    -- Set M.dailydir to our new temporary directory
    womwiki.dailydir = temp_dir_path:absolute()
  end)

  after_each(function()
    -- Restore the original M.dailydir
    if original_dailydir ~= nil then
      womwiki.dailydir = original_dailydir
    end
    -- Clean up the temporary directory
    if temp_dir_path and temp_dir_path:exists() then
      temp_dir_path:rmdir({ force = true }) -- force=true to remove non-empty dirs
    end
    original_dailydir = nil
    temp_dir_path = nil
  end)

  it('should return an empty list for an empty directory', function()
    local files = womwiki.list_files()
    assert.is_table(files)
    assert.is_empty(files)
  end)

  it('should return a list of file names in the directory', function()
    -- Create some dummy files in the temporary directory
    local file1 = Path:new(womwiki.dailydir, 'testfile1.md')
    file1:write('content1', 'w')
    local file2 = Path:new(womwiki.dailydir, 'another_note.txt')
    file2:write('content2', 'w')
    -- Create a dummy subdirectory to ensure it's not listed (if that's the behavior)
    local subdir = Path:new(womwiki.dailydir, 'subfolder')
    subdir:mkdir()

    local files = womwiki.list_files()
    assert.is_table(files)
    -- We expect fs_scandir to return names, so let's check for those.
    -- The order might not be guaranteed, so check for presence.
    assert.contains(files, 'testfile1.md')
    assert.contains(files, 'another_note.txt')
    
    -- Depending on how womwiki.list_files processes vim.loop.fs_scandir results,
    -- it might or might not list directories. fs_scandir itself lists them.
    -- If list_files is intended to only list files, this assertion is important.
    -- If it can list directories too, this should be adjusted.
    assert.not_contains(files, 'subfolder') 
    
    assert.are.equal(2, #files, 'Should only list the two files')
  end)

  it('should handle non-existent dailydir gracefully (optional test)', function()
    -- This test depends on how list_files is implemented to handle errors.
    -- For example, it might return an empty list, or nil, or raise an error.
    womwiki.dailydir = Path:new(os.tmpname(), 'non_existent_dir_for_sure'):absolute()
    
    -- Example: if it's expected to return an empty table on error
    local files = womwiki.list_files()
    assert.is_table(files)
    assert.is_empty(files)

    -- Or, if it's expected to return nil (adjust assertion accordingly)
    -- local files = womwiki.list_files()
    -- assert.is_nil(files)

    -- If it's expected to throw an error, you might use pcall or assert.has_error
    -- local success, result = pcall(womwiki.list_files)
    -- assert.is_false(success)
  end)

end)

-- (Make sure Path and womwiki are already required at the top of the file)
-- local Path = require('plenary.path')
-- local womwiki = require('utils.womwiki')
local spy = require('plenary.spy')

describe('womwiki.create_file_with_template()', function()
  local temp_output_dir
  local temp_template_dir
  local original_notify -- To spy on vim.notify

  before_each(function()
    temp_output_dir = Path:new(os.tmpname()):with_extension('_output')
    temp_output_dir:mkdir({ parents = true })

    temp_template_dir = Path:new(os.tmpname()):with_extension('_templates')
    temp_template_dir:mkdir({ parents = true })

    -- Spy on vim.notify
    original_notify = vim.notify
    vim.notify = spy.new(function(...)
      -- Can add some print statements here if needed for debugging spies
      -- print("vim.notify called with:", vim.inspect({...}))
    end)
    spy.reset(vim.notify) -- Reset call counts etc. for each test
  end)

  after_each(function()
    if temp_output_dir and temp_output_dir:exists() then
      temp_output_dir:rmdir({ force = true })
    end
    if temp_template_dir and temp_template_dir:exists() then
      temp_template_dir:rmdir({ force = true })
    end
    -- Restore original vim.notify
    vim.notify = original_notify
  end)

  it('should create a file with content from template and substitutions', function()
    local template_file = Path:new(temp_template_dir:absolute(), 'my_template.txt')
    template_file:write('Hello ${name}! Today is ${day}.', 'w')

    local target_filename = Path:new(temp_output_dir:absolute(), 'output.txt')
    local subs = { name = 'World', day = 'Monday' }

    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), subs)

    assert.is_true(result, 'Function should return true on success')
    assert.is_true(target_filename:exists(), 'Output file should exist')
    
    local content = target_filename:read()
    assert.are.equal('Hello World! Today is Monday.', content)
    assert.spy(vim.notify).was.called_with_matching(function(msg) return string.find(msg, "File created: ") end)
  end)

  it('should return false and notify if the target file already exists', function()
    local target_filename = Path:new(temp_output_dir:absolute(), 'existing_output.txt')
    target_filename:write('Original content', 'w') -- Pre-create the file

    local template_file = Path:new(temp_template_dir:absolute(), 'another_template.txt')
    template_file:write('Template content', 'w')

    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), {})

    assert.is_false(result, 'Function should return false if file exists')
    assert.spy(vim.notify).was.called_with_matching(function(msg) return string.find(msg, "File already exists: ") end)
    
    -- Ensure original file content is unchanged
    local content = target_filename:read()
    assert.are.equal('Original content', content)
  end)

  it('should return false and notify if the template file does not exist', function()
    local non_existent_template = Path:new(temp_template_dir:absolute(), 'ghost_template.txt')
    local target_filename = Path:new(temp_output_dir:absolute(), 'output_no_template.txt')

    local result = womwiki.create_file_with_template(target_filename:absolute(), non_existent_template:absolute(), {})

    assert.is_false(result, 'Function should return false if template not found')
    assert.is_false(target_filename:exists(), 'Output file should not be created')
    assert.spy(vim.notify).was.called_with_matching(function(msg) return string.find(msg, "Template not found: ") end)
  end)

  it('should handle templates with no substitution keys correctly', function()
    local template_file = Path:new(temp_template_dir:absolute(), 'simple_template.txt')
    template_file:write('Just plain text.', 'w')

    local target_filename = Path:new(temp_output_dir:absolute(), 'simple_output.txt')
    
    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), { name = 'Tester' })

    assert.is_true(result)
    local content = target_filename:read()
    assert.are.equal('Just plain text.', content) -- Substitutions for non-existent keys should not alter content
  end)

  it('should substitute multiple occurrences of the same key', function()
    local template_file = Path:new(temp_template_dir:absolute(), 'multi_template.txt')
    template_file:write('${greeting}, ${name}! Yes, ${greeting} indeed.', 'w')

    local target_filename = Path:new(temp_output_dir:absolute(), 'multi_output.txt')
    local subs = { greeting = 'Aloha', name = 'Kalani' }

    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), subs)
    assert.is_true(result)
    local content = target_filename:read()
    assert.are.equal('Aloha, Kalani! Yes, Aloha indeed.', content)
  end)
  
  it('should handle keys in subs that are not in the template', function()
    local template_file = Path:new(temp_template_dir:absolute(), 'subset_template.txt')
    template_file:write('Key: ${key1}', 'w')

    local target_filename = Path:new(temp_output_dir:absolute(), 'subset_output.txt')
    local subs = { key1 = 'value1', unused_key = 'value_unused' }
    
    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), subs)
    assert.is_true(result)
    local content = target_filename:read()
    assert.are.equal('Key: value1', content)
  end)

  it('should leave unsubstituted keys as they are (e.g. ${key_not_in_subs})', function()
    local template_file = Path:new(temp_template_dir:absolute(), 'unsubstituted_template.txt')
    template_file:write('Hello ${name}, your lucky number is ${number}.', 'w')

    local target_filename = Path:new(temp_output_dir:absolute(), 'unsubstituted_output.txt')
    local subs = { name = 'Nomad' }

    local result = womwiki.create_file_with_template(target_filename:absolute(), template_file:absolute(), subs)
    assert.is_true(result)
    local content = target_filename:read()
    assert.are.equal('Hello Nomad, your lucky number is ${number}.', content)
  end)
end)

-- (Make sure Path, womwiki, and spy are already required at the top of the file)
-- local Path = require('plenary.path')
-- local womwiki = require('utils.womwiki')
-- local spy = require('plenary.spy')

describe('womwiki.picker()', function()
  local test_choices
  local spies

  before_each(function()
    spies = {
      action1 = spy.new(function() end),
      action2 = spy.new(function() end)
    }
    test_choices = {
      { "Option 1", spies.action1 },
      { "Option 2", spies.action2 },
    }

    -- Spy on API functions that create UI elements or mappings
    spy.on(vim.api, "nvim_create_buf")
    spy.on(vim.api, "nvim_buf_set_lines")
    spy.on(vim.api, "nvim_open_win")
    spy.on(vim.api, "nvim_buf_set_keymap")
    spy.on(vim.api, "nvim_win_close") -- Though close is often called via :lua string in keymap

    -- Reset spies that might have been called in setup or other tests
    spy.reset_spies() 
  end)

  after_each(function()
    -- Restore spied functions
    spy.restore(vim.api, "nvim_create_buf")
    spy.restore(vim.api, "nvim_buf_set_lines")
    spy.restore(vim.api, "nvim_open_win")
    spy.restore(vim.api, "nvim_buf_set_keymap")
    spy.restore(vim.api, "nvim_win_close")
  end)

  it('should attempt to create a buffer, set lines, open window, and set keymaps', function()
    womwiki.picker(test_choices)

    assert.spy(vim.api.nvim_create_buf).was.called_with(false, true)
    assert.spy(vim.api.nvim_buf_set_lines).was.called() -- We can be more specific if needed
    assert.spy(vim.api.nvim_open_win).was.called()     -- We can be more specific if needed

    -- Check for essential keymaps
    -- For 'q'
    assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == 'q' end
    )
    -- For '<Esc>'
    assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == '<Esc>' end
    )
    -- For '<C-c>'
     assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == '<C-c>' end
    )
    -- For '<CR>'
    assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == '<CR>' end
    )
    -- For '1'
    assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == '1' end
    )
    -- For '2'
    assert.spy(vim.api.nvim_buf_set_keymap).was.called_with_matching(
      function(_, _, key, _, _) return key == '2' end
    )
  end)
end)

describe('womwiki.execute_selection()', function()
  local test_choices_for_exec
  local exec_spies
  local original_notify

  before_each(function() 
    exec_spies = {
      func1 = spy.new(function() end),
      func2 = spy.new(function() end),
    }
    test_choices_for_exec = {
      { "Exec Option 1", exec_spies.func1 },
      { "Exec Option 2", exec_spies.func2 },
    }

    -- Mock vim.api.nvim_win_get_cursor and vim.api.nvim_buf_get_lines for when index is nil
    spy.on(vim.api, "nvim_win_get_cursor", function(win_id) return {1, 0} end) -- Assume cursor is on 1st line
    spy.on(vim.api, "nvim_buf_get_lines", function(buf_id, start_line, end_line, strict_indexing)
      if start_line == 0 and end_line == 1 then -- Corresponds to cursor on 1st line
        return { "1: Exec Option 1" } -- Mocked line content
      end
      return {}
    end)
    
    spy.on(vim.api, "nvim_win_close")

    original_notify = vim.notify
    vim.notify = spy.new(function(...) end)

    spy.reset_spies()
  end)

  after_each(function() 
    spy.restore(vim.api, "nvim_win_get_cursor")
    spy.restore(vim.api, "nvim_buf_get_lines")
    spy.restore(vim.api, "nvim_win_close")
    vim.notify = original_notify
  end)

  it('should execute the correct function when an index is provided', function()
    -- Args: buf, win, index, choices_to_execute_from
    womwiki.execute_selection(0, 0, 1, test_choices_for_exec) 
    assert.spy(vim.api.nvim_win_close).was.called_with(0, true)
    assert.spy(exec_spies.func1).was.called()
    assert.spy(exec_spies.func2).was_not_called()
  end)

  it('should execute the correct function based on buffer line when index is nil (<CR> case)', function() 
    womwiki.execute_selection(0, 0, nil, test_choices_for_exec)
    assert.spy(vim.api.nvim_win_close).was.called_with(0, true)
    assert.spy(exec_spies.func1).was.called() -- Because our mock returns "1: Exec Option 1"
    assert.spy(exec_spies.func2).was_not_called()
  end)

  it('should call notify and not execute if index is out of bounds', function() 
    womwiki.execute_selection(0, 0, 99, test_choices_for_exec)
    assert.spy(vim.api.nvim_win_close).was_not_called()
    assert.spy(exec_spies.func1).was_not_called()
    assert.spy(exec_spies.func2).was_not_called()
    assert.spy(vim.notify).was.called_with_matching(function(msg) return string.find(msg, "Invalid selection") end)
  end)
  
  it('should call notify and not execute if line content does not provide a valid index', function() 
    spy.restore(vim.api, "nvim_buf_get_lines") -- remove previous mock
    spy.on(vim.api, "nvim_buf_get_lines", function(...) return {"Invalid Line Content"} end)
    
    womwiki.execute_selection(0, 0, nil, test_choices_for_exec)
    assert.spy(vim.api.nvim_win_close).was_not_called()
    assert.spy(exec_spies.func1).was_not_called()
    assert.spy(vim.notify).was.called_with_matching(function(msg) return string.find(msg, "Invalid selection") end)
  end)
end)
