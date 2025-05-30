local map = require("utils.keys").map

-- quick exit
map("i", "jk", "<esc>")


-- Diagnostic keymaps
map('n', 'gx', vim.diagnostic.open_float, "Show diagnostics under cursor")

-- Easier access to beginning and end of lines
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Move with shift-arrows
map("n", "<S-Left>", "<C-w><S-h>", "Move window to the left")
map("n", "<S-Down>", "<C-w><S-j>", "Move window down")
map("n", "<S-Up>", "<C-w><S-k>", "Move window up")
map("n", "<S-Right>", "<C-w><S-l>", "Move window to the right")

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Deleting buffers
local buffers = require("utils.buffers")
map("n", "<leader>db", buffers.delete_this, "Current buffer")
map("n", "<leader>do", buffers.delete_others, "Other buffers")
map("n", "<leader>da", buffers.delete_all, "All buffers")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Switch between light and dark modes
map("n", "<leader>ut", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end, "Toggle between light and dark themes")

-- Clear after search
map("n", "<leader><leader>", "<cmd>nohl<cr>", "Clear highlights")

-- Quick Fix toggle
map("n", "<leader>q", require("utils.misc").toggle_quickfix)

-- Insert current date
map("n", "<leader><leader>d", require("utils.misc").current_date)

-- LspSaga Mappings
map("n", "<leader>lt", ":Lspsaga term_toggle<cr>", "terminal toggle")
map("n", "<leader>lc", ":Lspsaga code_action<cr>", "code actions")
map("n", "<leader>lk", ":Lspsaga diagnostic_jump_next<cr>", "code actions")
map("n", "<leader>lo", ":Lspsaga outline<cr>", "outline")
-- map("n", "<leader>K", ":Lspsaga diagnostic_jump_prev<cr>", "code actions")

-- Copilot Chat
map("n", "<Leader>cc", "<cmd>CopilotChatToggle<CR>", "Copilot Chat Toggle")
map("n", "<Leader>cg", "<cmd>CopilotChatCommit<CR>", "Generate Commit message.")
map("n", "<Leader>cr", function()
    local choice = vim.fn.confirm('Reset Copilot Chat?', '&Yes\n&No', 2)
    if choice == 1 then
        vim.cmd("CopilotChatReset")
    end
end, "Reset current Copilot Chat")
map("n", "<Leader>cs", function()
    -- Save the current Copilot Chat with a user-defined name
    vim.ui.input({ prompt = 'Enter chat save name: ' }, function(input)
        if input and input ~= "" then
            vim.cmd("CopilotChatSave " .. input)
        else
            print("Save name cannot be empty.")
        end
    end)
end, "Save Copilot Chat with name")
map("n", "<Leader>cl", function()
    -- Load a saved Copilot Chat from a list of available chats
    local saved_chats = vim.fn.glob(vim.fn.stdpath("data") .. "/copilotchat_history/*.json", false, true)
    if #saved_chats == 0 then
        print("No saved chats found.")
        return
    end
    local chat_names = {}
    for _, path in ipairs(saved_chats) do
        local name = vim.fn.fnamemodify(path, ":t:r")
        table.insert(chat_names, name)
    end
    vim.ui.select(chat_names, {
        prompt = 'Select chat to load:',
    }, function(choice)
        if choice then
            vim.cmd("CopilotChatLoad " .. choice)
        end
    end)
end, "Load Copilot Chat from list")

-- Overseer (taks runner)
map("n", "<Leader>oo", "<cmd>OverseerToggle<CR>", "Overseer Toggle")
map("n", "<Leader>ol", "<cmd>OverseerLoadBundle<CR>", "Overseer Load Bundle")
map("n", "<Leader>or", "<cmd>OverseerRun<CR>", "Overseer Run")
map("n", "<Leader>e", function()
    local overseer = require("overseer")
    overseer.run_template({name = "Runner"}, function(task)
        if task then
            local current_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, '')
            vim.cmd("OverseerOpen")
            vim.api.nvim_set_current_win(current_win)
        end
    end)
end)
-- neovide mappings
if vim.g.neovide then
    map({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    map({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    map({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- some digraph cheaters
map("i", "<C-S-Right>", "<C-k>->", "→")
map("i", "<C-S-Left>", "<C-k><-", "←")

-- Copy selection to system clipboard. WSL only currently.
map({"n", "v"}, "<leader>Y", ":'<,'>w !clip.exe<CR>", "Copy selected lines to system clipboard.")
map({"n", "v"}, "<leader>y", require("utils.misc").SysYank, "Copy Selected texted to system clipboard.")

-- womwiki
map({"n", "v"}, "<leader>w", require("utils.womwiki").picker, "womwiki!")

-- mini
local function write_session()
    local session_name = ""
    vim.ui.input({ prompt = 'Enter New Session name: ' }, function(input)
        if input and input ~= "" then
            session_name = input
            MiniSessions.write(session_name)
        else
            print("Session name cannot be empty.")
        end
    end)
end
map({"n", "v"}, "<leader>msw", write_session, "Write MiniSession")
map({"n", "v"}, "<leader>mss", MiniSessions.select, "MiniSession selection")
map({"n", "v"}, "<leader>mf", MiniFiles.open, "MiniFiles")
map({"n", "v"}, "<leader>z",  MiniMisc.zoom, "MiniZooooooomI")

-- Snacks!
map({"n", "v"}, "<leader>lg",function()
    Snacks.lazygit()
end, "Toggle LazyGit")

map({"n", "v"}, "<leader>xd",function()
    if Snacks.dim.is_enabled == nil or not Snacks.dim.is_enabled then
        Snacks.dim.enable()
        Snacks.dim.is_enabled = true
    else
        Snacks.dim.disable()
        Snacks.dim.is_enabled = false
    end
end, "Dim")

-- Legacy
vim.cmd([[
function! NumberToggle()
    if (&relativenumber == 1)
        "echo "isRelative"
        :set norelativenumber
        :set foldcolumn=0
    else
        "echo "inElse"
        if (&number == 1)
        "echo "isNumber"
            :set nonumber
            :set relativenumber
        else
            :set number
        endif
    endif
endfunction
nnoremap <F2> :call NumberToggle()<CR>

function! DiffOrig()
    if &diff
        wincmd p | bdel | diffoff
    else
        vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
    endif
endfunction
map <leader>do :call DiffOrig()<cr>


]])
