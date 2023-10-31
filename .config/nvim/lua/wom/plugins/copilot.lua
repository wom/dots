return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        config = function()
            require('copilot').setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                    markdown = true,
                    python = true,
                    yaml = true,
                    lua = true,
                    bash = true,
                    sh = true,
                    go = true,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    ["."] = false,
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    },
}
