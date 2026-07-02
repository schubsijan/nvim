return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
    end,
  },
  {
    "ribru17/bamboo.nvim",
    name = "bamboo",
    lazy = true,
    config = function()
      require("bamboo").setup({
        transparent = true,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = true,
    config = function()
      require("tokyonight").setup({
        transparent = true
      })
    end
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = true
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = true
  },
  {
    "tahayvr/matteblack.nvim",
    name = "matteblack",
    lazy = true
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nordfox",
    lazy = true
  },
  {
    "gthelding/monokai-pro.nvim",
    name = "monokai-pro",
    lazy = true,
    config = function()
      require("monokai-pro").setup({
        filter = "ristretto",
        override = function()
          return {
            NonText = { fg = "#948a8b" },
            MiniIconsGrey = { fg = "#948a8b" },
            MiniIconsRed = { fg = "#fd6883" },
            MiniIconsBlue = { fg = "#85dacc" },
            MiniIconsGreen = { fg = "#adda78" },
            MiniIconsYellow = { fg = "#f9cc6c" },
            MiniIconsOrange = { fg = "#f38d70" },
            MiniIconsPurple = { fg = "#a8a9eb" },
            MiniIconsAzure = { fg = "#a8a9eb" },
            MiniIconsCyan = { fg = "#85dacc" },
          }
        end
      })
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      require("rose-pine").setup({
        variant = "dawn",
      })
    end
  },
  {
    "kepano/flexoki-neovim",
    name = "flexoki-light",
    lazy = true,
  },
  {
    "drewxs/ash.nvim",
    lazy = true,
    transparent = true,
  },
  { "rose-pine/neovim", name = "rose-pine-dawn", lazy = true },
  {
    "xero/miasma.nvim",
    name = "miasma",
    lazy = true,
  },
  {
    'everviolet/nvim',
    name = 'evergarden',
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      theme = {
        variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
        accent = 'green',
      },
      editor = {
        transparent_background = false,
        sign = { color = 'none' },
        float = {
          color = 'mantle',
          solid_border = false,
        },
        completion = {
          color = 'surface0',
        },
      },
    }
  },
  {
    "rgarofano/omarchy-theme.nvim",
    config = function()
      require("omarchy-theme").setup()
    end,
  },
}
