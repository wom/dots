local vkms = vim.keymap.set

-- lsp
vkms("n", "<Leader>lo", "<cmd>LspStop<CR>")
vkms("n", "<Leader>ls", "<cmd>LspStart<CR>")
vkms("n", "<Leader>lr", "<cmd>LspRestart<CR>")
vkms("n", "<Leader>li", "<cmd>LspInfo<CR>")

-- neotest
vkms("n", "<Leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end)
vkms("n", "<Leader>tl", function() require("neotest").run.run() end)
vkms("n", "<Leader>to", function() require("neotest").output.open({ enter = true }) end)
vkms("n", "<Leader>ts", function() require("neotest").run.stop() end)
vkms("n", "<Leader>td", function() require("neotest").run.run({strategy = "dap"}) end)
vkms("n", "<Leader>ta", function() require("neotest").summary.open() end)

-- Searching!
-- Search highlighted word in current buffer(s)
vkms("n", "<Leader>s", function() require('telescope.builtin').grep_string({grep_open_files=true, search=vim.fn.expand("<cword>"),}) end)
vkms("n", "<Leader>S", function() require('telescope.builtin').grep_string({search=vim.fn.expand("<cword>")}) end)

-- toggleterm
vkms("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<CR>")
vkms("n", "<Leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
vkms("n", "<Leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")

-- QuickFix
vkms("n", "]q", "<cmd>cn<CR>")
vkms("n", "[q", "<cmd>cp<CR>")
vkms("n", "<Leader>qq", require("utils").toggle_quickfix)

-- Harpoon!
vkms("n", "<Leader><leader>ha", function() require("harpoon.mark").add_file() end)
vkms("n", "<Leader>hh", function() require("harpoon.ui").toggle_quick_menu() end)
