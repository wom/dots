local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
            install_path })
end

local function conf(pluggy)
    require('configs.' .. pluggy)
end

local utils = require('utils')

local function config_dir()
    local _config_dir = utils.join_paths(utils.join_paths(os.getenv("HOME"), ".config"), "nvim")
    if not _config_dir then
        return vim.call("stdpath", "config")
    end
    return _config_dir
end

local function snapshot_dir()
    -- We attempt to store snapshots in same dot repo as our config; aid in reproducibility between dev envs.
    local _snapshot_dir = utils.join_paths(config_dir(), "snapshot")
    return _snapshot_dir
end

local config = {
    autoremove = true,
    snapshot_path = snapshot_dir(),
    -- To update a plugin
    --     `:PackerSync` followed by `:PackerSnapshot GOLD` (and check in/push after verifying)
    --     May need 
    --     :checkhealth -- Audit results, may need
    --     :TSUpdate vim python help markdown markdown_inline-- insert required languages
    snapshot = 'GOLD',
}
require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim'
        -- <plugins>
        use {
            "nvim-treesitter/nvim-treesitter",
            requires = {
                "nvim-treesitter/nvim-treesitter-context"
            },
            config = conf('treesitter')
        }
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
        -- Native LSP stuffs
        use({ "jose-elias-alvarez/null-ls.nvim" })
        use({ "L3MON4D3/LuaSnip", config = conf("luasnip") })

        use {
            "neovim/nvim-lspconfig", -- lspconfig!
            "williamboman/mason.nvim", -- lets nvim manage local LSPs/etc
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp", -- autocompletion framework
            "hrsh7th/cmp-nvim-lsp", -- LSP Autocompletion provider
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "glepnir/lspsaga.nvim",
            config = conf('lsp')
        }
        -- Debugger!
        use { "mfussenegger/nvim-dap" }
        use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
        use {
            "mfussenegger/nvim-dap-python",
            requires = { "mfussenegger/nvim-dap" }
        }
        --        ---
        --        -- Notes.
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
        use { "Vimjas/vim-python-pep8-indent" } -- Needed because treesitter sucks at indenting Python
        use { "tpope/vim-fugitive" }
        use {
            "catppuccin/nvim",
            as = "catppuccin",
            config = conf('catppuccin')
        }
        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons', -- optional, for file icons
            }
        }
        -- snippets, not lua based...
        use { "rafamadriz/friendly-snippets" }
        -- Code commenter
        use { 'numToStr/Comment.nvim' }
        use { 'stevearc/overseer.nvim',
            config = conf('overseer')
        }
        --        -- Startup Screen!
        --use { 'glepnir/dashboard-nvim' }
        -- Session/Workspace Management!
        use { 'natecraddock/workspaces.nvim' }
        ----
        -- Status Line
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }
        use {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig"
        }
        ----
        --        -- Buffers @ top
        use {
            "akinsho/bufferline.nvim",
            tag = "v2.*",
            requires = 'kyazdani42/nvim-web-devicons'
        }
        -- ... copilot? Copilot!
        use { "github/copilot.vim" }
        --
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

        -- show indent because.
        use {
            "lukas-reineke/indent-blankline.nvim",
            config = conf('indentline')
        }
        use {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = conf('trouble')
        }

        -- </plugins>
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = config,
})
-- print [[ Plugins Loaded ]]
