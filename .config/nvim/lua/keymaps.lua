local vkms = vim.keymap.set

-- -- magma (If we install jupyter/etc in local venv..
-- vkms("n", "<Leader>mi", "<cmd>MagmaInit<CR>")
-- vkms("n", "<Leader>ml", "<cmd>MagmaEvaluateLine<CR>")
-- vkms("v", "<Leader>m<CR>", ":<C-u>MagmaEvaluateVisual<CR>")
-- vkms("n", "<Leader>mc", "<cmd>MagmaReevaluateCell<CR>")
-- vkms("n", "<Leader>m<CR>", "<cmd>MagmaShowOutput<CR>")

-- lsp
vkms("n", "<Leader>lo", "<cmd>LspStop<CR>")
vkms("n", "<Leader>ls", "<cmd>LspStart<CR>")

-- neotest
vkms("n", "<Leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end)
vkms("n", "<Leader>tl", function() require("neotest").run.run() end)
vkms("n", "<Leader>to", function() require("neotest").output.open({ enter = true }) end)
vkms("n", "<Leader>ts", function() require("neotest").run.stop() end)
vkms("n", "<Leader>td", function() require("neotest").run.run({strategy = "dap"}) end)
vkms("n", "<Leader>ta", function() require("neotest").summary.open() end)

-- toggleterm
vkms("n", "<Leader>tf", "<cmd>ToggleTerm direction=float<CR>")
vkms("n", "<Leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
vkms("n", "<Leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")

-- QuickFix
vkms("n", "]q", "<cmd>cn<CR>")
vkms("n", "[q", "<cmd>cp<CR>")
vkms("n", "<Leader>qq", require("utils").toggle_quickfix)
