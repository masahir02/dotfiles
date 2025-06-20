vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<esc><esc>", ":on<cr>")
vim.keymap.set("n", "<leader>d", ":bd<cr>")
vim.keymap.set("n", "q:", "")
vim.keymap.set("n", "q/", "")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

vim.keymap.set("n", "gK", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })

vim.keymap.set("v", "p", '"_dP')

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").update({ show = false })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*",
  command = 'if getline(1) =~ "^#!" | :silent !chmod +x %',
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  command = ":silent !mkdir -p %:p:h",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "go",
  callback = function()
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 8
    vim.opt.softtabstop = 8
    vim.opt.tabstop = 8
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "python",
    "sql",
  },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
  end,
})

vim.opt.clipboard = "unnamed"
vim.opt.confirm = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "▫︎", eol = "↵" }
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
    source = "if_many",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "ibhagwan/fzf-lua",
      opts = {
        winopts = {
          fullscreen = true,
          preview = {
            layout = "vertical",
            vertical = "down:70%",
          },
        },
        keymap = {
          builtin = {
            ["<c-d>"] = "preview-page-down",
            ["<c-u>"] = "preview-page-up",
          },
        },
      },
      keys = {
        { "<leader><space>", "<cmd>FzfLua<cr>" },
        { "<tab>", "<cmd>FzfLua buffers<cr>" },
        { "<leader>f", "<cmd>FzfLua files<cr>" },
        { "<leader>g", "<cmd>FzfLua live_grep<cr>" },
        { "<leader>h", "<cmd>FzfLua oldfiles<cr>" },
      },
    },

    {
      "neovim/nvim-lspconfig",
    },

    {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "sqlfluff",
          "prettier",
        },
      },
    },

    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "gopls",
          "pyright",
          "ts_ls",
          "bashls",
          "gh_actions_ls",
        },
      },
    },

    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      config = function()
        local cmp = require("cmp")

        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<s-tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<cr>"] = cmp.mapping.confirm({ select = true }),
            ["<c-space>"] = cmp.mapping.complete(),
          }),
          sources = cmp.config.sources({
            { name = "copilot" },
            { name = "nvim_lsp" },
            { name = "path" },
          }, {
            { name = "buffer" },
          }),
        })
      end,
    },

    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },

    {
      "zbirenbaum/copilot-cmp",
      opts = {},
    },

    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      build = "make tiktoken",
      opts = {
        model = "gpt-4.1",
        show_help = false,
        sticky = {
          "#files",
          "/Jp",
        },
        prompts = {
          Jp = {
            prompt = "日本語でお願いします",
          },
        },
      },
      keys = {
        { "<leader>l", "<cmd>CopilotChatToggle<cr>" },
      },
    },

    {
      "nvim-tree/nvim-web-devicons",
      opts = {},
    },

    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },

    {
      "folke/tokyonight.nvim",
      config = function()
        vim.cmd([[colorscheme tokyonight-storm]])
      end,
    },

    {
      "windwp/nvim-autopairs",
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
        { "<leader>b", "<cmd>GitBlameToggle<cr>" },
      },
    },

    {
      "nvimdev/indentmini.nvim",
      event = "VeryLazy",
      opts = {},
    },

    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      opts = {},
    },

    {
      "ya2s/nvim-cursorline",
      opts = {},
    },

    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          go = { "gopls", "gofmt" },
          lua = { "stylua" },
          sql = { "sqlfluff" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
      },
    },

    {
      "linrongbin16/gitlinker.nvim",
      cmd = "GitLink",
      opts = {},
      keys = {
        { "<leader>y", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank and Open" },
        { "<leader>o", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
      },
    },

    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = true,
    },
  },
  change_detection = { enabled = true },
  checker = { enabled = true },
})
