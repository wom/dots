-- Global keymappings. Pull into own file?
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local gopts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, gopts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, gopts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, gopts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, gopts)



_G.load_config = function()
    -- Uncomment for more detailed info
    -- vim.lsp.set_log_level 'trace'
    local nvim_lsp = require 'lspconfig'
    local on_attach = function(client, bufnr)
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- status line/breadcrubs
        -- ToDo: This doesn't seem to work?
        require("nvim-navic").attach(client, bufnr)
        -- Mappings.
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        ----
        --
    end

    local cmd = { 'pyright-langserver', '--stdio' } -- needed for elixirls, omnisharp, sumneko_lua
    -- Before setting up servers; set it up to install them!
    require("nvim-lsp-installer").setup {}
    -- LspInstallInfo  for overview of available language servers.
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

    -- autocomplete!
    -- Not sure if this luasnip stuff is OK.
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local cmp = require 'cmp'
    local luasnip = require("luasnip")
    cmp.setup {
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            })
        },
        sources = {
            { name = 'nvim_lsp' },
        }
    }

    -- Tree Browser 
    require("nvim-tree").setup()

    --Dashboard Setup
    local home = os.getenv('HOME')
    local db = require('dashboard')
    db.preview_command = 'cat | lolcat -F 0.3' -- make lolcat safer?
    db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
    db.preview_file_height = 12
    db.preview_file_width = 80
    db.custom_center = {
        {icon = '💼 ',
        desc = 'Select Workspace',
        action =  'WorkspacesOpen'},
        {icon = '  ',
        desc = 'Find File         ',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
        shortcut = '(\\ff)'},
        {icon = '   ',
        desc ='File Browser      ',
        action =  'Telescope file_browser',
        shortcut = '(\\fn)'},
        {icon = '  ',
        desc = 'Grep              ',
        action = 'Telescope live_grep',
        shortcut = '(\\fg)'},
    }


    -- Code Runner
    require('code_runner').setup({
        -- put here the commands by filetype
        mode = 'toggle',
        focus = false,
        filetype = {
            bash = "bash",
            lua = "lua",
            python = "python3 -u",
            rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt"
        },
    })
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
    require('lualine').setup({
        sections = {
            lualine_c = {
                { navic.get_location, cond = navic.is_available },
            }
        }
    })

    -- Buffers @ top
    vim.opt.termguicolors = true
    require("bufferline").setup {
        options = {
            offsets = {{filetype = "NvimTree", text = "File Explorer"}},
        }
    }
    -- print [[ Config Loaded ]]
end
_G.load_config()
