return {
    {
        -- FORMATTING
        "stevearc/conform.nvim",
        config = function()
            -- disable autoformat by default
            vim.g.disable_autoformat = true
            local conform = require("conform")

            conform.setup({
                log_level = vim.log.levels.DEBUG, -- :ConformInfo to show log info
                formatters_by_ft = {
                    -- https://www.gnu.org/software/gawk/manual/gawk.html
                    awk = { "gawk" },
                    -- https://github.com/mvdan/gofumpt
                    -- https://pkg.go.dev/golang.org/x/tools/cmd/goimports (auto imports)
                    -- https://github.com/incu6us/goimports-reviser
                    go = { "gofumpt", "goimports", "goimports-reviser" },
                    -- https://github.com/threedaymonk/htmlbeautifier
                    html = { "htmlbeautifier" },
                    -- https://github.com/mantoni/eslint_d.js/
                    -- https://github.com/beautifier/js-beautify
                    javascript = { "eslint_d", "js_beautify" },
                    -- https://github.com/stedolan/jq
                    jq = { "jq" },
                    -- https://github.com/rhysd/fixjson
                    json = { "fixjson" },
                    -- lua!
                    lua = { "stylua" },
                    -- https://github.com/executablebooks/mdformat
                    markdown = { "mdformat" },
                    -- https://github.com/psf/black
                    -- https://github.com/PyCQA/isort
                    python = { "black", "isort" },
                    -- https://github.com/rust-lang/rustfmt
                    rust = { "rustfmt" },
                    -- https://github.com/koalaman/shellcheck
                    sh = { "shellcheck" },
                    -- https://www.terraform.io/docs/cli/commands/fmt.html
                    -- https://opentofu.org/docs/cli/commands/fmt/  NOTE: This is an alternative `tofu_fmt`
                    toml = { "taplo" },
                    -- http://xmlsoft.org/xmllint.html
                    xml = { "xmllint" },
                    -- https://github.com/mikefarah/yq
                    yq = { "yq" },
                    -- https://github.com/ziglang/zig
                    zig = { "zigfmt" },
                    zon = { "zigfmt" },
                    -- https://github.com/koalaman/shellcheck
                    zsh = { "shellcheck" }
                },
                format_after_save = function(bufnr)
                    -- disable with a global or buffer-local variable
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return { timeout_ms = 5000, lsp_format = "fallback" }
                end
            })

            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
                vim.notify("Disabling AutoFormat", vim.log.levels.INFO)
            end, {
                desc = "Disable autoformat-on-save",
                bang = true,
            })

            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
                vim.notify("Enabling AutoFormat", vim.log.levels.INFO)
            end, {
                desc = "Re-enable autoformat-on-save",
            })

            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_format = "fallback", range = range })
                vim.notify("Formatting buffer.", vim.log.levels.INFO)
            end, { range = true })

            vim.keymap.set("n", "<leader>fi", "<Cmd>ConformInfo<CR>", { desc = "Show Conform log" })
            vim.keymap.set("n", "<leader>ff", "<Cmd>Format<CR>", { desc = "Format current buffer." })
            vim.keymap.set("n", "<leader>fd", "<Cmd>FormatDisable<CR>", { desc = "Disable autoformat-on-save" })
            vim.keymap.set("n", "<leader>fe", "<Cmd>FormatEnable<CR>", { desc = "Re-enable autoformat-on-save" })
            -- vim.keymap.set("n", "<leader>fg", function() vim.cmd("silent !gofumpt -w %") end, { desc = "Format file with gofumpt" })

            -- DISABLED: in favour of format_on_save.
            --
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --   group = vim.api.nvim_create_augroup("Formatting", { clear = true }),
            --   pattern = "*",
            --   callback = function(args)
            --     require("conform").format({ bufnr = args.buf })
            --   end
            -- })
        end,
    },
    -- RE-FORMAT TABLE MARKDOWN
    {
        'Kicamon/markdown-table-mode.nvim',
        config = function()
            require('markdown-table-mode').setup()
        end
    }
}
