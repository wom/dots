local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local function load_plugins0()
  require('packer').startup {
    {
      'wbthomason/packer.nvim',
      'neovim/nvim-lspconfig',
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
                    'kyazdani42/nvim-web-devicons'
                }
            }
        }
        use {
             'vimwiki/vimwiki',
             config = function()
                 vim.g.vimwiki_list = {
                     {
                         path = '~/',
                         syntax = 'markdown',
                         ext  = '.md',
                     }
                 }
                 vim.g.vimwiki_ext2syntax = {
                     ['.md'] = 'markdown',
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
        -- Native LSP
        use "neovim/nvim-lspconfig"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "hrsh7th/cmp-nvim-lsp"
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }
        -- </plugins>
        if packer_bootstrap then
            require('packer').sync()
        end
    end)
   -- print [[ Plugins Loaded ]]
end
_G.load_config = function()
  vim.lsp.set_log_level 'trace'
  if vim.fn.has 'nvim-0.5.1' == 1 then
    require('vim.lsp.log').set_format_func(vim.inspect)
  end
  local nvim_lsp = require 'lspconfig'
  local on_attach = function(_, bufnr)
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  end

  local name = 'pyright'
  local cmd = { 'pyright-langserver', '--stdio' } -- needed for elixirls, omnisharp, sumneko_lua

  nvim_lsp[name].setup {
    cmd = cmd,
    on_attach = on_attach,
  }

-- LSP logs exist under $HOME/.cache/nvim/lsp.log.
   -- print [[ Config Loaded ]]
end

--load_plugins0()
load_plugins()
-- require('packer').sync()  -- SomeDay on demand maybe. Once a week?
_G.load_config() 

