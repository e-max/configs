return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'nanotech/jellybeans.vim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'jellybeans'

      -- You can configure highlights by doing something like:
      --   vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    'metalelf0/jellybeans-nvim',
    lazy = false,
    priority = 1000,

    dependencies = {
      {
        'rktjmp/lush.nvim',
      },
    },
    config = function() end,
    init = function()
      vim.cmd.colorscheme 'jellybeans-nvim'
      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Type gui=none'
      local lush = require 'lush'
      local jb = require 'lush_theme.jellybeans-nvim'
      local hsl = lush.hsl

      -- Now we will extend the colorscheme
      local spec = lush.extends({ jb }).with(function()
        return {
          -- make the telescope popup look like the pmenu
          -- FlashLabel { cterm = 'bold', gui = 'bold', fg = hsl '#a6e3a2', bg = hsl '#1e1e2f' },

          FlashLabel { cterm = 'bold', gui = 'bold', bg = hsl(130, 100, 70), fg = hsl(1, 100, 50) }, -- |:substitute| replacement text highlighting
          Substitute { bg = hsl(208, 100, 80), fg = hsl(1, 100, 80) }, -- |:substitute| replacement text highlighting
          -- Search { bg = hsl(208, 100, 80), fg = hsl(1, 100, 80) }, -- |:substitute| replacement text highlighting
          Type { fg = hsl '#ffb964', gui = 'none' }, -- (preferred) int, long, char, etc.
        }
      end)

      -- then pass the extended spec to lush for application
      return lush(spec)
    end,
  },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      --vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'ellisonleao/gruvbox.nvim', name = 'gruvbox', priority = 1000, config = true },
  { 'savq/melange-nvim', priority = 1000 },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
