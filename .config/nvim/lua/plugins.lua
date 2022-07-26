local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
            "williamboman/mason.nvim", -- lets nvim manage local LSPs/etc
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp", -- autocompletion framework
            "hrsh7th/cmp-nvim-lsp", -- LSP Autocompletion provider
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip" -- snippets!
        }
        -- snippets, not lua based...
        use { "rafamadriz/friendly-snippets" }
        -- Code commenter - this seems wonk
        use { 'numToStr/Comment.nvim' }
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
            "akinsho/bufferline.nvim",
            tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons'
        }
        -- ... copilot? CoPilot!
        use { "github/copilot.vim" }
        -- Debugger!
        use { "mfussenegger/nvim-dap" }
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
        use { "mfussenegger/nvim-dap-python", requires = {"mfussenegger/nvim-dap"}  }
        -- </plugins>
        if packer_bootstrap then
            require("packer").sync()
        end
    end)
    -- print [[ Plugins Loaded ]]
end

load_plugins()

