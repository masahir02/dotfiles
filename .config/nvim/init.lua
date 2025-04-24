vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<ESC><ESC>', ':on<CR>')
vim.keymap.set('n', '<Leader>/', ':set nu!<CR>:set list!<CR>:set wrap!<CR>:echo<CR>')
vim.keymap.set('n', '<Leader>d', ':bd<CR>')
vim.keymap.set('n', '<Leader>n', ':vnew<CR>')
vim.keymap.set('n', 'q:', '')
vim.keymap.set('n', 'q/', '')
vim.keymap.set('v', 'p', '"_dP')

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

vim.opt.clipboard = 'unnamed'
vim.opt.confirm = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '▫︎', eol = '↵' }
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.wrap = false

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    severity = vim.diagnostic.severity.ERROR,
    source = 'if_many',
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
      end,
    },

    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },

    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
          }),
          sources = cmp.config.sources({
            { name = 'copilot' },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
            { name = 'path' },
          }),
        })
      end,
    },

    {
      'zbirenbaum/copilot.lua',
      config = function()
        require('copilot').setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },

    {
      'zbirenbaum/copilot-cmp',
      opts = {},
    },

    {
      'CopilotC-Nvim/CopilotChat.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      build = 'make tiktoken',
      opts = {
        model = 'gpt-4o',
        agent = 'copilot',

        show_help = false,

        question_header = '　🍙　',
        answer_header = '　🤖　',
        error_header = '　🔥　',

        prompts = {
          Explain = {
            prompt = '選択されたコードについて、段落形式の文章で説明を書いてください。',
            system_prompt = 'COPILOT_EXPLAIN',
          },
          Review = {
            prompt = '選択されたコードをレビューしてください。',
            system_prompt = 'COPILOT_REVIEW',
          },
          Fix = {
            prompt = 'このコードには問題があります。問題点を特定し、修正したコードに書き換えてください。何が間違っていたのか、またその修正がどのように問題を解決するのかを説明してください。',
          },
          Optimize = {
            prompt = '選択されたコードのパフォーマンスと可読性を向上させるために最適化してください。最適化の方針と、その変更による利点を説明してください。',
          },
          Docs = {
            prompt = '選択されたコードにドキュメントコメントを追加してください。',
          },
          Tests = {
            prompt = 'このコードのテストを生成してください。',
          },
          Commit = {
            prompt = '変更内容に対して、Commitizen規約に従ったコミットメッセージを書いてください。タイトルは50文字以内に収め、本文は72文字で改行してください。gitcommitコードブロックの形式で書いてください。',
            context = 'git:staged',
          },
        },
      },
      keys = {
        { '<Leader>l', '<cmd>CopilotChatToggle<cr>' },
        { '<Leader>c', '<cmd>CopilotChatReset<cr>' },
      }
    },

    {
      'nvim-tree/nvim-web-devicons',
      opts = {},
    },

    {
      'folke/todo-comments.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {},
    },

    {
      'folke/tokyonight.nvim',
      config = function()
        vim.cmd[[colorscheme tokyonight]]
      end,
    },

    {
      'windwp/nvim-autopairs',
      opts = {},
    },

    {
      "f-person/git-blame.nvim",
      event = "VeryLazy",
      opts = {
        message_template = " <date> by <author>",
        date_format = "%Y-%m-%d %H:%M:%S (%r)",
        virtual_text_column = 1,
      },
      keys = {
        { "<Leader>b", "<cmd>GitBlameToggle<cr>" },
      },
    },

    {
      'nvimdev/indentmini.nvim',
      event = 'VeryLazy',
      opts = {},
    },

    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      opts = {},
    },

    {
      'yamatsum/nvim-cursorline',
      opts = {},
    },
  },
  checker = { enabled = true },
})
