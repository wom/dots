return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup()
            require("utils.keys").map(
                { "n", "v" },
                "<leader>n",
                "<cmd>NeoTreeRevealToggle<cr>",
                "Toggle file explorer"
            )
        end,
    },
}
