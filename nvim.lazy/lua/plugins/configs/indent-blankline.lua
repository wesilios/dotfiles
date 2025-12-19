-- lua/plugins/configs/indent-blankline.lua
require('ibl').setup({
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})

