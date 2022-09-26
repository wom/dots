local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

local function conf(pluggy)
    require('configs.' .. pluggy)
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- <plugins>
    use 'tpope/vim-fugitive'
    use "EdenEast/nightfox.nvim" -- color Scheme!
    use {
        "nvim-treesitter/nvim-treesitter",
        requires ={
            "nvim-treesitter/nvim-treesitter-context"
        },
        config = conf('treesitter')
    }
    use { "Vimjas/vim-python-pep8-indent" } -- Needed because treesitter sucks at indenting Python
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {
                'nvim-lua/plenary.nvim',
                'BurntSushi/ripgrep',
                'sharkdp/fd',
                'kyazdani42/nvim-web-devicons',
                "nvim-telescope/telescope-file-browser.nvim",
                "nvim-telescope/telescope-project.nvim",
            }
        }
    }
    ---
    -- Notes?
    use {
        'vimwiki/vimwiki',
        config = function()
            vim.g.vimwiki_list = {
                {
                    path   = '~/vimwiki',
                    syntax = 'markdown',
                    ext    = '.wiki',
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
    -- OPne Day.
    -- use {
    --     "nvim-neorg/neorg",
    --     requires = "nvim-lua/plenary.nvim",
    --     ft = "norg",
    --     after = "nvim-treesitter",
    --     config = conf('neorg')
    -- }

    ---
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
        "L3MON4D3/LuaSnip", -- snippets!
        "saadparwaiz1/cmp_luasnip",
        "jose-elias-alvarez/null-ls.nvim",
        "glepnir/lspsaga.nvim",
        config = conf('lsp')
    }
    -- snippets, not lua based...
    use { "rafamadriz/friendly-snippets" }
    -- Code commenter - this seems wonk
    use { 'numToStr/Comment.nvim' }
    -- Code Runner - Not a huuuuge fan, trying others.
    -- use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'stevearc/overseer.nvim',
        config = conf('overseer')
    }
    -- Startup Screen!
    use { 'glepnir/dashboard-nvim' }
    -- Session/Workspace Management!
    use { 'natecraddock/workspaces.nvim' }
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
    -- ... copilot? Copilot!
    -- use { "github/copilot.vim" }
    -- Debugger!
    use { "mfussenegger/nvim-dap" }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { "mfussenegger/nvim-dap-python", requires = { "mfussenegger/nvim-dap" } }

    -- Whichkey! popups
    use {
        "folke/which-key.nvim",
        config = conf('whichkey')
    }

    -- Pretty Nootifications
    use {
        "rcarriga/nvim-notify",
        config = conf('notify')
    }

    -- UT Runner!
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",

        }
    }
    -- terminal toggles!
    use { "akinsho/toggleterm.nvim" }

    -- Harpooooon
    use { 'ThePrimeagen/harpoon', requires = { "nvim-lua/plenary.nvim" } }
    -- show indent because.
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = conf('indentline')
    }
    -- </plugins>
    if packer_bootstrap then
        require("packer").sync()
    end
end)
-- print [[ Plugins Loaded ]]
