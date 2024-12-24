local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  }

  use {
    'ibhagwan/fzf-lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  }

  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
  }

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup()
    end
  }

  use {
    'akinsho/flutter-tools.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('flutter-tools').setup {}
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end
  }

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd('colorscheme tokyonight-moon')
    end
  }

  use 'junegunn/vim-easy-align'

  use 'tpope/vim-commentary'

  use 'tpope/vim-surround'

  use 'sheerun/vim-polyglot'

  use {
    'yamatsum/nvim-cursorline',
    config = function()
      require('nvim-cursorline').setup {}
    end
  }

  use 'tpope/vim-fugitive'

  use 'prisma/vim-prisma'

  use 'github/copilot.vim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
