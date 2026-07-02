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
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require(configpath .. 'gitsigns')
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
      require('conform').setup(opts)
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
  {
    'neovim/nvim-lspconfig',
    config = function()
      require(configpath .. 'lsp')
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require(configpath .. 'mason')
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require(configpath .. 'nvim-cmp')
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    config = function()
      require(configpath .. 'roslyn')
    end,
  },
  {
    -- Debug Framework
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require(configpath .. 'nvim-dap')
    end,
    event = 'VeryLazy',
  },
  { 'nvim-neotest/nvim-nio' },
  {
    -- UI for debugging
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require(configpath .. 'nvim-dap-ui')
    end,
  },
  {
    'nvim-neotest/neotest',
    requires = {
      {
        'Issafalcon/neotest-dotnet',
      },
    },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require(configpath .. 'neotest')
    end,
  },
  {
    'Issafalcon/neotest-dotnet',
    lazy = false,
    dependencies = {
      'nvim-neotest/neotest',
    },
  },
  {
    'ramboe/ramboe-dotnet-utils',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require(configpath .. 'comment')
    end,
  },
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require(configpath .. 'mini-nvim')
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    config = function()
      require(configpath .. 'render-markdown').setup()
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require(configpath .. 'indent-blankline')
    end,
  },
  -- Help System (lazy-loaded on keymap)
  {
    dir = vim.fn.stdpath('config') .. '/lua/core',
    name = 'help-system',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = function()
      return require(configpath .. 'nvim-help').keys
    end,
    config = function()
      require(configpath .. 'nvim-help').init()
    end,
  },
})
