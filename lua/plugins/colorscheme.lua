-- plugins.colorscheme

return {
  -- gruvbox colorscheme
  { "ellisonleao/gruvbox.nvim" },

  -- gruvbox modified
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
  },

  -- moonfly colorscheme
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("moonfly")
    -- end,
  },

  -- solarized-osaka colorscheme
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
    -- config = function()
    --   vim.cmd.colorscheme("solarized-osaka")
    -- end,
  },

  -- everforest colorscheme
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
  },

  -- https://github.com/projekt0n/github-nvim-theme?tab=readme-ov-file#supported-colorschemes--comparisons
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },

  -- set colorscheme here
  {
    "LazyVim/LazyVim",
    opts = {
      -- here precisely
      colorscheme = "gruvbox-material",
    },
  },
}
