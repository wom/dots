local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local function load_plugins0()
    -- Minimal test load funciton for debugging
    require('packer').startup {
        {
            'wbthomason/packer.nvim',
        },
        config = {
            package_root = package_root,
            compile_path = compile_path,
        },
    }
end
local function load_plugins()
    require('packer').startup(function(use)
        use 'wbthomason/packer.nvim'
        -- <plugins>
        use 'tpope/vim-fugitive' 
        use "EdenEast/nightfox.nvim" -- color Scheme!
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                {
                    'nvim-lua/plenary.nvim',
                    'BurntSushi/ripgrep',
                    'sharkdp/fd',
                    'nvim-treesitter/nvim-treesitter',
                    'kyazdani42/nvim-web-devicons',
                    "nvim-telescope/telescope-file-browser.nvim",
                    "nvim-telescope/telescope-project.nvim"
                }
            }
        }
        use {
            'vimwiki/vimwiki',
            config = function()
                vim.g.vimwiki_list = {
                    {
                        path = '~/vimwiki',
                        syntax = 'markdown',
                        ext  = '.wiki',
                    }
                }
                vim.g.vimwiki_ext2syntax = {
                    ['.md'] = 'markdown',
                    ['.wiki'] = 'markdown',
                    ['.markdown'] = 'markdown',
                    ['.mdown'] = 'markdown',
                }
            end
        }
        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons', -- optional, for file icons
            },
            tag = 'nightly' -- optional, updated every week. (see issue #1193)
        }
        -- Native LSP stuffs
        use {
            "williamboman/nvim-lsp-installer",
            "neovim/nvim-lspconfig"
            -- eventually I want code completion stuff
            -- "hrsh7th/nvim-cmp",
            -- "hrsh7th/cmp-buffer",
            -- "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lsp"
        }
        -- Code commenter 
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }
        -- Code Runner
        use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
        -- Startup Screen!
        use {'glepnir/dashboard-nvim'}
        -- Session/Workspace Management!
        use {'natecraddock/workspaces.nvim'}
        -- Status Line
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }
        -- breadcrumbs! Why doesn't it work in pylance?
        use {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig"
        }
        -- Buffers @ top
        use {
            'akinsho/bufferline.nvim',
            tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons'
        }
        
        -- </plugins>
        if packer_bootstrap then
            require('packer').sync()
        end
    end)
    -- print [[ Plugins Loaded ]]
end
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
    nvim_lsp['pyright'].setup {
        cmd = cmd,
        on_attach = on_attach,
    }
    nvim_lsp['sumneko_lua'].setup {
       --  on_attach = on_attach,
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
                    '~/src/src1,
                    '~/src/src2,

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

--load_plugins0()
load_plugins()
-- require('packer').sync()  -- SomeDay on demand maybe. Once a week?
_G.load_config() 

