return {
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            local wk = require("which-key")
            wk.setup()
            wk.add(
                {
                    { "<leader>b", group = "Debugging" },
                    { "<leader>d", group = "Delete/Close" },
                    { "<leader>f", group = "File" },
                    { "<leader>g", group = "Git" },
                    { "<leader>l", group = "LSP" },
                    { "<leader>q", group = "Quit" },
                    { "<leader>s", group = "Search" },
                    { "<leader>u", group = "UI" },
                }
            )
        end,
    },
}
