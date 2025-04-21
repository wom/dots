return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "j-hui/fidget.nvim",
                tag = "legacy",
                event = "LspAttach",
            },
            "folke/neodev.nvim",
            "RRethy/vim-illuminate",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Set up Mason before anything else
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "bashls",
                    "yamlls",
                    "gopls",
                },
                automatic_installation = true,
            })

            -- Quick access via keymap
            require("utils.keys").map("n", "<leader>M", "<cmd>Mason<cr>", "Show Mason")

            -- Neodev setup before LSP config
            require("neodev").setup()

            -- Turn on LSP status information
            require("fidget").setup()

            -- Set up cool signs for diagnostics
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Diagnostic config
            local config = {
                virtual_text = false,
                signs = {
                    active = signs,
                },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }
            vim.diagnostic.config(config)

            -- This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                local lsp_map = require("utils.keys").lsp_map

                lsp_map("<leader>lr", vim.lsp.buf.rename, bufnr, "Rename symbol")
                lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code action")
                lsp_map("<leader>ld", vim.lsp.buf.type_definition, bufnr, "Type definition")
                lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")

                lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
                lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
                lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
                lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
                lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })

                -- Attach and configure vim-illuminate
                require("illuminate").on_attach(client)
            end

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Lua
            require("lspconfig")["lua_ls"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            })

            -- yaml
            require('lspconfig').yamlls.setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = true,
                            url = "https://www.schemastore.org/api/json/catalog.json",
                        },
                        -- Manual schema selection - uncomment the ones you need
                        schemas = {
                            -- Kubernetes schemas - uncomment when working with k8s
                            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.yaml",

                            -- More specific Kubernetes schemas if needed
                            -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/deployment-apps-v1.json"] = "/deployment.yaml",
                            -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/service-v1.json"] = "/service.yaml",

                            -- Azure DevOps pipeline schemas
                            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "{/src/pipeline/**/*.{yml,yaml},/pipeline/**/*.{yml,yaml}}",

                            -- Docker Compose schema
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yml",

                            -- GitHub Actions
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
                        },
                        validate = true,
                        format = {
                            enable = true,
                        },
                        hover = true,
                        completion = true,
                    },
                },
            }

            -- python !
            local util = require("lspconfig/util")
            require("lspconfig").pyright.setup({
                capabilities = capabilities,
                -- on_attach = attach,
                root_dir = util.root_pattern(".git", ".env", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt"),
                flags = {
                    debounce_text_changes = 1,
                },
                settings = {
                    python = {
                        analysis = {
                            --stubPath = "./typings",
                            autoSearchPaths = false,
                            useLibraryCodeForTypes = false,
                            diagnosticMode = "openFilesOnly",
                            extraPaths = {},  -- You can add extra paths here if needed
                        },
                        venvPath = "",  -- Let Pyright auto-discover the venv
                        pythonPath = "",  -- Let Pyright auto-discover the Python path
                    },
                },
            })

            -- Go
            require("lspconfig").gopls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {"gopls"},
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                    },
                },
            })

            -- Bash!
            require("lspconfig").bashls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { "sh", "bash" },
                settings = {
                    bashIde = {
                        globPattern = "*@(.sh|.inc|.bash|.command)",
                    },
                },
            })

        end,
    },
}
