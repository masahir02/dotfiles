vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<ESC><ESC>', ':on<CR>')
vim.keymap.set('n', '<Leader>/', ':set nu!<CR>:set list!<CR>:set wrap!<CR>:echo<CR>')
vim.keymap.set('n', '<Leader>d', ':bd<CR>')
vim.keymap.set('n', '<Leader>n', ':enew<CR>')
vim.keymap.set('n', '<Leader>q', ':q<CR>')
vim.keymap.set('n', 'q:', '')
vim.keymap.set('n', 'q/', '')
vim.keymap.set('x', 'p', '"_xP')

vim.api.nvim_create_autocmd({'BufWritePost'}, {
  pattern = '*',
  command = 'if getline(1) =~ "^#!" | :silent !chmod +x %'
})

vim.api.nvim_create_autocmd({'BufWritePre'}, {
  pattern = '*',
  command = ':silent !mkdir -p %:p:h'
})

vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'go',
  callback = function()
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 8
    vim.opt.softtabstop = 8
    vim.opt.tabstop = 8
  end
})

vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'python',
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
  end
})

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamed'
vim.opt.cmdheight = 1
vim.opt.confirm = true
vim.opt.encoding = 'utf8'
vim.opt.expandtab = true
vim.opt.fileencoding = 'utf8'
vim.opt.fileencodings = 'utf8'
vim.opt.fileformat = 'unix'
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '_', eol = '↵' }
vim.opt.number = true
vim.opt.ruler = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.wildmenu = true
vim.opt.wrap = false

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    severity = vim.diagnostic.severity.ERROR,
    source = "if_many",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    {
      'ibhagwan/fzf-lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {
        winopts = {
          fullscreen = true,
          preview = {
            layout = 'vertical',
            vertical = 'down:70%',
          },
        },
        keymap = {
          builtin = {
            ['<C-d>'] = 'preview-page-down',
            ['<C-u>'] = 'preview-page-up',
          },
        },
      },
      keys = {
        { '<Leader><space>', '<cmd>FzfLua<cr>' },
        { '<Tab>', '<cmd>FzfLua buffers<cr>' },
        { '<Leader>f', '<cmd>FzfLua files<cr>' },
        { '<Leader>g', '<cmd>FzfLua live_grep<cr>' },
        { '<Leader>r', '<cmd>FzfLua oldfiles<cr>' },
      },
    },

    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
      }
    },

    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
      config = function()
        require('mason').setup()
        require('mason-lspconfig').setup()

        local on_attach = function(_, bufnr)
          local bufmap = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
          end
          bufmap('n', 'gd', vim.lsp.buf.definition)
          bufmap('n', 'gi', vim.lsp.buf.implementation)
          bufmap('n', 'gr', vim.lsp.buf.references)
          bufmap('n', 'K', vim.lsp.buf.hover)
          bufmap('n', '<leader>rn', vim.lsp.buf.rename)
          bufmap('n', '[d', vim.diagnostic.goto_prev)
          bufmap('n', ']d', vim.diagnostic.goto_next)
        end

        require('mason-lspconfig').setup_handlers {
          function(server_name)
            require('lspconfig')[server_name].setup({
              on_attach = on_attach,
            })
          end,
        }

        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
        })
      end,
    },

    {
      'folke/todo-comments.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {},
    },

    {
      'CopilotC-Nvim/CopilotChat.nvim',
      dependencies = {
        { 'github/copilot.vim' },
        { 'nvim-lua/plenary.nvim', branch = 'master' },
      },
      build = 'make tiktoken',
      opts = {},
    },

    { 'windwp/nvim-autopairs', opts = {} },

    {
      'folke/tokyonight.nvim',
      opts = {},
      config = function()
        vim.cmd[[colorscheme tokyonight]]
      end,
    },
  },
  checker = { enabled = true },
})
