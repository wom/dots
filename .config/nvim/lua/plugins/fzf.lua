return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
    end,
    keys = {
        { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Files" },
        { "<C-_>", "<cmd>FzfLua live_grep<cr>", desc = "Grep" }, -- maps to ctrl-/
        { "<leader>fz", "<cmd>FzfLua builtin<cr>", desc = "FzfLua pickers" },
    },
}
