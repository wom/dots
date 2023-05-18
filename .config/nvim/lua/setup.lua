-- Global keymappings. Pull into own file?
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local gopts = { noremap=true, silent=true }
-- Awesome diagnostics
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, gopts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, gopts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, gopts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, gopts)
-- Coderunner
-- vim.keymap.set('n', '<leader>e', ':RunFile<CR>', gopts)
-----
-- GitHub Copilot
-- Disable for unknown filetypes
vim.g.copilot_filetypes = {
    ["*"] = false,
    python = true,
    go = true,
    lua = true,
    bash = true,
    rust = true,
    html = true,
    yaml = true,
    javascript = true,
}
-----

-- Uncomment for more detailed info
-- vim.lsp.set_log_level 'trace'
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- status line/breadcrubs
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
    -- Mappings.
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)  -- done via lspsaga in keymaps
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    -- Debugging via DAP!
    vim.keymap.set("n", "<leader>c", ":lua require'dap'.continue()<CR>")
    vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
    vim.keymap.set("n", "<F4>", ":lua require'dap'.step_into()<CR>")
    vim.keymap.set("n", "<F5>", ":lua require'dap'.step_out()<CR>")
    vim.keymap.set("n", "<leader>b", ":lua require('dap').toggle_breakpoint()<CR>")
    vim.keymap.set("n", "<leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
    vim.keymap.set("n", "<leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
    vim.keymap.set("n", "<leader>du", ":lua require('dapui').toggle()<CR>")
    --vim.keymap.set("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>")
    --
end

local cmd = { 'pyright-langserver', '--stdio' } -- needed for elixirls, omnisharp, sumneko_lua
-- Before setting up servers; set it up to install them!
require("mason").setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}
require("mason-lspconfig").setup {
    ensure_installed = {
        "sumneko_lua",
        "pyright",
        "marksman",
        "ruff_lsp",
    },
}
-- :Mason for overview of available language servers/linters/formatters/etc
-- LSP logs exist under $HOME/.cache/nvim/lsp.log.
local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
nvim_lsp['pyright'].setup {
    cmd = cmd,
    on_attach = on_attach,
    flags = lsp_flags,
}
local rustcmd = { 'rust-analyzer' }
nvim_lsp['rust_analyzer'].setup {
    cmd = rustcmd,
    on_attach = on_attach,
    flags = lsp_flags,
}
-- yaml-language-server
local ymlbin_name = 'yaml-language-server'
local ymlcmd = { ymlbin_name, '--stdio' }
nvim_lsp['yamlls'].setup{
    cmd = ymlcmd,
    filetypes = { 'yaml', 'yaml.docker-compose' },
    root_dir = require('lsputils').find_git_ancestor,
    single_file_support = true,
    settings = {
      -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
      redhat = { telemetry = { enabled = false } },
        yaml = {
        schemas = {
            ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
            ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
            ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
            ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
            ['http://json.schemastore.org/stylelintrc'] = '.stylelintrc.{yml,yaml}',
            ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
            ['https://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
            ['https://json.schemastore.org/cloudbuild'] = '*cloudbuild.{yml,yaml}',
            ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = '*.{yml,yaml}'
        }
        }
    },
}
nvim_lsp['sumneko_lua'].setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

-- These likely need better config
nvim_lsp['bashls'].setup {
    on_attach = on_attach,
    -- capabilities = capabilities, -- Define the capabilities better
    flags =lsp_flags,
}
nvim_lsp['dockerls'].setup { }
-- nvim_lsp['yamlls'].setup { }
nvim_lsp['marksman'].setup {
    filetypes = {"markdown", "vimwiki"}
}
nvim_lsp['ltex'].setup {
    filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "text", "vimwiki" },

}
nvim_lsp['ruff_lsp'].setup {
    on_attach = on_attach,
    init_options = {
        settings = {

            args = {},
        }
    }
}





-- /end neosnip

-- Tree Browser.
require("nvim-tree").setup()

--Dashboard Setup
-- local home = os.getenv('HOME')
-- local db = require('dashboard')
--db.preview_command = 'cat | lolcat -F 0.3' -- make lolcat safer?
--db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
--db.preview_file_height = 12
--db.preview_file_width = 80
--db.custom_center = {
--    {icon = '💼 ',
--    desc = 'Select Workspace',
--    action =  'WorkspacesOpen'},
--    {icon = '  ',
--    desc = 'Find File         ',
--    action = 'Telescope find_files find_command=rg,--hidden,--files',
--    shortcut = '(\\ff)'},
--    {icon = '   ',
--    desc ='File Browser      ',
--    action =  'Telescope file_browser',
--    shortcut = '(\\fn)'},
--    {icon = '  ',
--    desc = 'Grep              ',
--    action = 'Telescope live_grep',
--    shortcut = '(\\fg)'},
--}


-- Code Runner
-- require('code_runner').setup({
--     -- put here the commands by filetype
--     mode = 'term',
--     focus = false,
--     filetype = {
--         bash = "bash",
--         sh= "bash",
--         lua = "lua",
--         python = "python3 -u",
--         rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt"
--     },
-- })
-- Telescope Plugins
require('telescope').setup {
    extensions = {
        project = {
            base_dirs = {
                '~/src',

            },
            hidden_files = false, -- default: false
            theme = "dropdown",
            display_type = "full"
        }
    }
}
require("telescope").load_extension("file_browser")
require("telescope").load_extension("project")
-- Workspace Management
require("workspaces").setup {
    hooks = {
        open = {'Telescope file_browser'},
    },
}
-- Status line
local navic = require("nvim-navic")
-- lazy-updates on large files.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.api.nvim_buf_line_count(0) > 1000 then
            vim.b.navic_lazy_update_context = true
        end
    end,
})

require('lualine').setup({
    sections = {
        lualine_c = {
            { navic.get_location, cond = navic.is_available },
        }
    }
})

-- Buffers @ top
require("bufferline").setup {
    options = {
        offsets = {{filetype = "NvimTree", text = "File Explorer"}},
    }
}
-- DAP!
-- Requires that debugpy is installed in specified interpreter.
require('dap-python').setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     dapui.close()
-- end
--comments!
require('Comment').setup( {
    toggler = {
        ---Line-comment toggle keymap
        -- line = 'gcc', default
        line = '<C-_><C-_>', -- '_' == forward slash ('/')
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    opleader = {
        ---Line-comment keymap
        -- line = 'gc', default
        line = '<C-_>',
        ---Block-comment keymap
        block = 'gb',
    },
    mappings = {
        basic = true,
        extra = false,
        extended = false,
    },
})

-- Setting up Neotest runner.
require("neotest").setup({
  adapters = {
    require("neotest-python")({
        -- Requires TreeSitter Python support installed.
        -- :TSInstall python
        dap = { justMyCode = false },
        args = {"--log-level", "DEBUG"},
        runner = "pytest",
        -- is_test_file = function(file_path)
        --     -- print [[ Checking if Python test... ]]
        --     return true
        --     -- return file_path:match("test%.py$")
        -- end,
    }),
  }
})
-- Setting up toggleable terminal
require("toggleterm").setup()
-- print [[ Config Loaded ]]
