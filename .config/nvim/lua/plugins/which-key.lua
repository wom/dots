return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            local wkey = require("which-key")
            wkey.register({
                ["<leader>"] = {
                    -- d = { -- Steal this I think; i hate the f mappings I have.
                    --   name = "debugging/diff",
                    --   b = "Debug Breakpoint toggle",
                    --   c = "Debug Continue",
                    --   f = "Diffview file",
                    --   h = "Debug Step out",
                    --   i = "Debug Inspect selection",
                    --   j = "Debug Step over",
                    --   l = "Debug Step in",
                    --   o = "Debug open float",
                    --   r = "Debug repl open",
                    --   s = "Debug Stop",
                    --   v = "Diffview toggle",
                    -- },
                    f = { -- This looks stealable
                        name = "find/files",
                        --   a = "File find (all)",
                        --   b = "Find buffers",
                        --   ["<C-b>"] = "File browser",
                        --   ["<C-g>"] = "File grep (select directory)",
                        --   f = "File find (no . or gitignore)",
                        --   g = "File grep (all)",
                        --   G = "File grep (exclude directory)",
                        --   h = "Find help",
                        --   s = "Find symbols",
                        --   S = "Find workspace symbols",
                        --   t = "Find treesitter",
                        --   w = "Find word under cursor",
                    },
                    o = {
                        name = "Overseer (Task Runner)",
                    },
                    q = {
                        name = "Quickfix",
                        q = "Toggle",
                        --   e = "Edit",
                    },
                    t = {
                        name = "test/terminal",
                        a = "Test all summary",
                        d = "Test debug nearest",
                        f = "Terminal float",
                        h = "Terminal horizontal",
                        l = "Test nearest",
                        o = "Test output",
                        s = "Test stop",
                        t = "Test suite run",
                        v = "Terminal vertical",
                    },
                    s = "Search Open Buffers",
                    S = "Search Workspace ",
                    w = {
                        name = "vimwiki",
                    },
                },
            })
        end,
        opts = {},
    },
}
