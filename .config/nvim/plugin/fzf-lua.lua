require('fzf-lua').setup{
  winopts = {
    fullscreen = true,
    preview = {
      layout = 'holizontal',
      vertical = 'down:70%',
    },
  },
  keymap     = {
    builtin = {
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
  },
}

local builtin = require('fzf-lua')
vim.keymap.set('n', '<Leader><space>', builtin.builtin, {})
vim.keymap.set('n', '<Tab>', builtin.buffers, {})
vim.keymap.set('n', '<Leader>f', builtin.files, {})
vim.keymap.set('n', '<Leader>g', builtin.live_grep, {})
