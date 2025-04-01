-- NOTE: Use the following to disable warnings/errors.
--  Ruff
--      x = 1 / 0  # noqa: F841  # Ignore unused variable warning
--
-- yamllint (on same line as issue or line above issue, or across whole file)
--      # yamllint disable-line rule:<RULE>
--      # yamllint disable rule:<RULE>
--
-- codespell
--      //codespell:ignore
--
return {
    {
        -- LINTING
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
            lint.linters_by_ft = {
                -- https://www.gnu.org/software/gawk/
                awk = { "gawk" },
                -- https://github.com/jorisroovers/gitlint
                git = { "gitlint" },
                -- https://github.com/codespell-project/codespell
                -- https://golangci-lint.run/
                go = { "codespell", "golangcilint" },
                -- https://htmlhint.com/
                -- https://www.html-tidy.org/
                json = { "jsonlint" },

                -- WARNING: Removed luacheck linter due to problem with folke/neodev
                -- https://github.com/mpeterv/luacheck
                -- lua = { "luacheck" },

                -- https://github.com/mrtazz/checkmake
                make = { "checkmake" },
                -- https://alexjs.com/
                -- https://github.com/DavidAnson/markdownlint
                -- https://docs.getwoke.tech/
                markdown = { "alex", "markdownlint", "woke" },
                python = { "ruff" },
                -- https://github.com/rust-lang/rust-clippy
                rust = { "clippy" },
                -- https://www.gnu.org/software/bash/
                -- https://www.shellcheck.net/
                sh = { "bash", "shellcheck" },

            }


            -- Checkmake requires a ini file in the current directory
            -- Otherwise you have to specify a global one
            lint.linters.checkmake.args = {
                "--format='{{.LineNumber}}:{{.Rule}}:{{.Violation}}\n'",
                "--config", os.getenv("HOME") .. "/.config/checkmake.ini",
            }

            -- Spectral requires a ruleset in the current directory
            -- Otherwise you have to specify a global one
            lint.linters.spectral.args = {
                "lint", "-f", "json", "--ruleset", os.getenv("HOME") .. "/.spectral.yaml",
            }

            -- NOTE: We need custom logic for handling YAML linting.
            -- https://github.com/rhysd/actionlint
            -- https://github.com/adrienverge/yamllint (https://yamllint.readthedocs.io/en/stable/rules.html)
            -- https://github.com/stoplightio/spectral (`npm install -g @stoplight/spectral-cli`)
            vim.api.nvim_create_autocmd({
                "BufReadPost", "BufWritePost", "InsertLeave"
            }, {
                group = vim.api.nvim_create_augroup("Linting", { clear = true }),
                callback = function(ev)
                    -- print(string.format('event fired: %s', vim.inspect(ev)))
                    -- print(vim.bo.filetype)
                    if (string.find(ev.file, ".github/workflows/") or string.find(ev.file, ".github/actions/")) and vim.bo.filetype == "yaml" then
                        lint.try_lint("actionlint")
                    elseif vim.bo.filetype == "yaml" then
                        local first_line = vim.fn.getline(1)
                        if string.find(first_line, "openapi:") then
                            lint.try_lint("spectral")
                        else
                            lint.try_lint("yamllint")
                        end
                    else
                        lint.try_lint()
                    end
                end
            })
        end
    },
}
