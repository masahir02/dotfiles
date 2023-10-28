require('fzf-lua').setup{
  winopts = {
    fullscreen = true,
    preview = {
      layout = 'holizontal',
      vertical = 'down:70%',
    },
  },
}

local builtin = require('fzf-lua')
vim.keymap.set('n', '<Leader><space>', builtin.files, {})
vim.keymap.set('n', '<Tab>', builtin.buffers, {})
