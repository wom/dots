return {
    {
        "zbirenbaum/copilot.lua",
        enabled = true,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                python = true,
                bash = true,
                lua = true,
                go = true,
                yaml = true,
            },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            -- { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
            highlight_headers = false,
            separator = '---',
            error_header = '> [!ERROR] Error',
        },
    },
    {
        "nvim-cmp",
        dependencies = {
            {
                "zbirenbaum/copilot-cmp",
                opts = {},
            },
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#E06C75" })
        end,
    },
}
