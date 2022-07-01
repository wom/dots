local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
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
  -- </plugins>
  if packer_bootstrap then
    require('packer').sync()
  end
end)
