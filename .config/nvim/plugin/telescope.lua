require('telescope').setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.99,
      preview_cutoff = 0,
      width = 0.99
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>f', builtin.find_files, {})
vim.keymap.set('n', '<Leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<Tab>', builtin.buffers, {})
vim.keymap.set('n', '<Leader><space>', ':Telescope<CR>')
