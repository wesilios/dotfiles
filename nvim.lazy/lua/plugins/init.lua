-- lua/plugins/init.lua
-- Bootstrap lazy.nvim
local configpath = 'plugins.configs.'
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require(configpath .. 'treesitter')
    end,
    run = ':TSUpdate',
  },
  { 'nvim-treesitter/playground' },
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require(configpath .. 'telescope')
    end,
  },
  {
    'gbprod/yanky.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      require(configpath .. 'yanky').setup()
    end,
  },
  { 'kyazdani42/nvim-web-devicons' },
  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require(configpath .. 'colorscheme').switchtogruvbox()
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  {
    'tpope/vim-fugitive',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      require(configpath .. 'vim-fugitive')
    end,
  },
  {
    'mbbill/undotree',
    config = function()
      require(configpath .. 'undotree')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require(configpath .. 'which-key')
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require(configpath .. 'harpoon')
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = require(configpath .. 'conform').options(),
    config = function(_, opts)
      require('conform').setup(options)
      require(configpath .. 'conform').config()
    end,
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require(configpath .. 'lualine')
    end,
  },
})
