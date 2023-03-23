vim.g.mapleader = ' '

vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<C-n>', ':bn<CR>')
vim.keymap.set('n', '<C-p>', ':bp<CR>')
vim.keymap.set('n', '<ESC><ESC>', ':on<CR>')
vim.keymap.set('n', '<Leader>/', ':set nu!<CR>:set list!<CR>:set wrap!<CR>:echo<CR>')
vim.keymap.set('n', '<Leader>d', ':bd<CR>')
vim.keymap.set('n', '<Leader>n', ':enew<CR>')
vim.keymap.set('n', '<Leader>q', ':q<CR>')
vim.keymap.set('n', 'q:', '')
vim.keymap.set('n', 'q/', '')

vim.cmd([[xnoremap <expr> p 'pgv"'.v:register.'y`>']])

vim.cmd([[autocmd BufWritePost * if getline(1) =~ "^#!" | :silent !chmod +x %]])

vim.cmd([[autocmd BufWritePre * :silent !mkdir -p %:p:h]])

vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'go',
  callback = function(args)
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 8
    vim.opt.softtabstop = 8
    vim.opt.tabstop = 8
  end
})

vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'python',
  callback = function(args)
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

require("plugins")
