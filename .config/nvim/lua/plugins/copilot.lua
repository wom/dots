local prompts = {
    Typo = {
        prompt = "> /COPILOT_GENERATE\n\nYou are a senior developer, with years of experience developing and in devops. There's at least one typo in this code. Please specify the line numbers for each typo. Do not modify additional code. Simply tell me what line the typos are on, and give me the corrected code. Only supply the correct lines, not the entire code. Above that, tell me what the code was previously and what you changed.",
    },
    Comments = {
        prompt = "> /COPILOT_GENERATE\n\nYou are a senior developer, with years of experience developing and in devops. Please provide comments for the following code. Include a block at the top, with a brief explanation and smaller comments by functions.",
    },
    Explain = {
        prompt = "> /COPILOT_GENERATE\n\nYou are a senior developer, with years of experience developing and in devops. Please explain how the following code works.",
    },
    Fix = {
        prompt = "> /COPILOT_GENERATE\n\nYou are a senior developer, with years of experience developing and in devops. Please fix the following code. Do not display line numbers.",
        mapping = "<leader>acf",
        description = "CopilotChat - Fix Code",
    },
    Review = {
        prompt = "> /COPILOT_GENERATE\n\nYou are a senior developer, with years of experience developing and in devops. Please review the following code and provide suggestions for improvement.",
    },
    Help = {
        prompt = "You are a senior developer, with years of experience developing and in devops. Please help me, I will explain my problem below.",
    },
}
return
    {
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
            config = function()
                require("copilot").setup({
                    panel = {
                        layout = {
                            position = "right",
                            ratio = 0.5,
                        },
                    },
                    suggestion = {
                        auto_trigger = true,
                    },
                })

                vim.api.nvim_create_autocmd("User", {
                    pattern = "BlinkCmpMenuOpen",
                    callback = function()
                        require("copilot.suggestion").dismiss()
                        vim.b.copilot_suggestion_hidden = true
                    end,
                })

                vim.api.nvim_create_autocmd("User", {
                    pattern = "BlinkCmpMenuClose",
                    callback = function()
                        require("copilot.suggestion").next()
                        vim.b.copilot_suggestion_hidden = false
                    end,
                })
            end,
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
                prompts = prompts,
                -- model = 'gpt-4o-2024-11-20',
                -- model = 'claude-3.7-sonnet',
                -- model = 'claude-3.7-sonnet-thought',
                -- model = 'gpt-4.1',
                model = 'claude-sonnet-4',
                -- model = 'gemini-2.5-pro',
                highlight_headers = false,
                separator = '---',
                error_header = '> [!ERROR] Error',
                event = "VeryLazy",
                mappings = {
                    complete = {
                        insert = '<Tab>',
                    },
                    close = {
                        normal = 'q',
                        -- insert  '<C-c>',
                        insert = '',
                    },
                    reset = {
                        normal = '<C-l>',
                        insert = '<C-l>',
                    },
                    submit_prompt = {
                        normal = '<CR>',
                        insert = '<C-s>',
                    },
                    toggle_sticky = {
                        normal = 'grr',
                    },
                    clear_stickies = {
                        normal = 'grx',
                    },
                    accept_diff = {
                        normal = '<C-y>',
                        insert = '<C-y>',
                    },
                    jump_to_diff = {
                        normal = 'gj',
                    },
                    quickfix_answers = {
                        normal = 'gqa',
                    },
                    quickfix_diffs = {
                        normal = 'gqd',
                    },
                    yank_diff = {
                        normal = 'gy',
                        register = '"', -- Default register to use for yanking
                    },
                    show_diff = {
                        normal = 'gd',
                        full_diff = false, -- Show full diff instead of unified diff when showing diff window
                    },
                    show_info = {
                        normal = 'gi',
                    },
                    show_context = {
                        normal = 'gc',
                    },
                    show_help = {
                        normal = 'gh',
                    },
                },

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
