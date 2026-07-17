return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    preset = 'obsidian',
    anti_conceal = {
      ignore = {
        head_background = true,
        head_icon = true,
        head_border = true,
        code_background = true,
        indent = true,
        sign = true,
        virtual_lines = true,
      },
    },
    completions = { lsp = { enabled = true } },
    heading = {
      sign = true,
      signs = { '#' },
      icons = { '', '', '', '', '', '' },
      position = 'inline',
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
    },
    code = {
      sign = false,
      width = 'block',
      left_pad = 1,
      right_pad = 1,
    },
    dash = {
      icon = '',
      width = 'full',
    },
    bullet = {
      icons = { '' },
      right_pad = 0.9,
    },


    link = {
      wiki = { icon = '' },
      hyperlink = '',
      email = '',
      footnote = { icon = '' },
    },
    quote = { repeat_linebreak = true },
    pipe_table = { preset = 'round' },
  },
  config = function(_, opts)
    local render = require 'render-markdown'
    render.setup(opts)
    local colors = {
      { 'H1', '#bf616a' }, { 'H2', '#a3be8c' },
      { 'H3', '#ebcb8b' }, { 'H4', '#81a1c1' },
      { 'H5', '#b48ead' }, { 'H6', '#b48ead' },
    }
    for _, c in ipairs(colors) do
      local name, fg = c[1], c[2]
      vim.api.nvim_set_hl(0, 'RenderMarkdown' .. name, { fg = fg })
      vim.api.nvim_set_hl(0, 'RenderMarkdown' .. name .. 'Bg', { fg = fg, bg = '#3b4252' })
    end
    vim.api.nvim_set_hl(0, '@markup.italic', { fg = '#e5c688', italic = true })
    vim.api.nvim_set_hl(0, '@markup.link', { fg = '#81a1c1', underline = false })
    vim.api.nvim_set_hl(0, '@markup.link.url', { fg = '#81a1c1', underline = false })
    vim.api.nvim_set_hl(0, 'RenderMarkdownLink', { fg = '#81a1c1', underline = false })
    vim.api.nvim_set_hl(0, 'RenderMarkdownWikiLink', { fg = '#81a1c1', underline = false })
    vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { fg = '#888e99' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote1', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote2', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote3', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote4', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote5', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote6', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownInlineHighlight', { bg = '#7e7026', fg = '#d3d8e3' })
  end,
  ft = { 'markdown' },
}
