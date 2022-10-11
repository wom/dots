local vkms = vim.keymap.set

-- lsp
vkms("n", "<Leader>lo", "<cmd>LspStop<CR>")
vkms("n", "<Leader>ls", "<cmd>LspStart<CR>")
vkms("n", "<Leader>lr", "<cmd>LspRestart<CR>")
vkms("n", "<Leader>li", "<cmd>LspInfo<CR>")
vkms("n", "<Leader>lf", function() vim.lsp.buf.format() end)
vkms("v", "<Leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")

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
vkms("n", "<Leader>ha", function() require("harpoon.mark").add_file() end)
vkms("n", "<Leader>hh", function() require("harpoon.ui").toggle_quick_menu() end)

--overseer!
--
vkms("n", "<Leader>oo", "<cmd>OverseerToggle<CR>")
vkms("n", "<Leader>ol", "<cmd>OverseerLoadBundle<CR>")
vkms("n", "<Leader>or", "<cmd>OverseerRun<CR>")
vkms("n", "<Leader>e", function()
    local overseer = require("overseer")
    overseer.run_template({name = "Runner"}, function(task)
        if task then
            overseer.run_action(task, 'open float')
            -- overseer.run_action(task, 'open hsplit')
        end
    end)
end)

-- LSPSaga!
--

-- Lsp finder find the symbol definition implmement reference
-- when you use action in finder like open vsplit then your can
-- use <C-t> to jump back
vkms("n", "<leader>gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
vkms("n", "<leader>gr", "<cmd>Lspsaga rename<CR>", { silent = true })
vkms("n", "<leader>go", "<cmd>LSoutlineToggle<CR>",{ silent = true })
vkms("n", "<leader>gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
vkms("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Saga Diagnostics
vkms("n", "<leader>k", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Snippets
vim.keymap.set({ "i", "s" }, "<c-j>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })
vkms({ "i", "s" }, "<c-k>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })
vkms("i", "<c-l>", function()
    local ls = require("luasnip")
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

-- comment ToDo stuff
vkms("n", "<leader>xt", "<cmd>TodoTelescope<CR>", { silent = true })
-- Lua
vkms("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
vkms("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
vkms("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
vkms("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
vkms("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
vkms("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {silent = true, noremap = true})
-- Trouble mappings...
--
