--[[
┌─────────────────────────────────────────────────────────────┐
│                        Yanky.nvim                           │
│              Enhanced clipboard history for Neovim          │
└─────────────────────────────────────────────────────────────┘

Features:
  • Maintains 100 entries in your clipboard history
  • Preserves history between Neovim sessions
  • Highlights text when yanking or pasting

Keymaps:
  • y     → Yank text
  • p/P   → Put after/before cursor
  • gp/gP → Put after/before selection
  • <C-j> → Previous entry in yank history
  • <C-k> → Next entry in yank history
  • <leader>p → Browse yank history
--]]
return {
    "gbprod/yanky.nvim",
    opts = { },
    dependencies = { "folke/snacks.nvim" },
    highlight = {
        on_put = true,
        on_yank = true,
        timer = 500,
    },
    ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
    },
    picker = {
        select = {
            action = nil, -- nil to use default put action
        },
    },
    keys = {
        {
            "<leader>p",
            function()
                Snacks.picker.yanky()
            end,
            mode = { "n", "x" },
            desc = "Open Yank History",
        },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
        { "<c-j>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
        { "<c-k>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
    }
}
