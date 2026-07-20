return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  -- LaTeX-Rendering benötigt: (1) latex treesitter parser → :TSInstall latex
  --                          (2) latex2text (von pylatexenc) → pip install pylatexenc
  opts = {
    preset = 'obsidian',
    on = {
      render = function(ctx)
        local ns = vim.api.nvim_create_namespace('rmd-arrows')
        vim.api.nvim_buf_clear_namespace(ctx.buf, ns, 0, -1)
        local top = vim.fn.line('w0') - 1
        local bot = vim.fn.line('w$') - 1
        local cursor = vim.api.nvim_win_get_cursor(ctx.win)
        local lines = vim.api.nvim_buf_get_lines(ctx.buf, top, bot + 1, false)
        local arrows = { { '<->', '↔' }, { '<=>', '⇔' }, { '->', '→' }, { '<-', '←' }, { '=>', '⇒' }, { '<=', '⇐' } }
        for i, line in ipairs(lines) do
          local row = top + i - 1
          if row ~= cursor[1] - 1 then
            local pos = 1
            while pos <= #line do
              local found = false
              for _, a in ipairs(arrows) do
                local pat, cchar = a[1], a[2]
                if #line >= pos + #pat - 1 and line:sub(pos, pos + #pat - 1) == pat then
                  vim.api.nvim_buf_set_extmark(ctx.buf, ns, row, pos - 1, {
                    end_row = row, end_col = pos - 1 + #pat,
                    conceal = '',
                    virt_text = { { cchar } },
                    virt_text_pos = 'inline',
                    priority = 200,
                  })
                  pos = pos + #pat
                  found = true
                  break
                end
              end
              if not found then
                pos = pos + 1
              end
            end
          end
        end
      end,
      clear = function(ctx)
        local ns = vim.api.nvim_create_namespace('rmd-arrows')
        vim.api.nvim_buf_clear_namespace(ctx.buf, ns, 0, -1)
      end,
    },
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
      footnote = {
        icon = '',
      },
      image = '',
      email = '',
      hyperlink = '',
      wiki = {
        icon = '',
        scope_highlight = 'my-link',
      },
      custom = {
        web = { icon = '', pattern = '^http' },
        apple = { icon = '', pattern = 'apple%.com', kind = 'url' },
        discord = { icon = '', pattern = 'discord%.com', kind = 'url' },
        github = { icon = '', pattern = 'github%.com', kind = 'url' },
        gitlab = { icon = '', pattern = 'gitlab%.com', kind = 'url' },
        google = { icon = '', pattern = 'google%.com', kind = 'url' },
        hackernews = { icon = '', pattern = 'ycombinator%.com', kind = 'url' },
        linkedin = { icon = '', pattern = 'linkedin%.com', kind = 'url' },
        microsoft = { icon = '', pattern = 'microsoft%.com', kind = 'url' },
        neovim = { icon = '', pattern = 'neovim%.io', kind = 'url' },
        reddit = { icon = '', pattern = 'reddit%.com', kind = 'url' },
        slack = { icon = '', pattern = 'slack%.com', kind = 'url' },
        stackoverflow = { icon = '', pattern = 'stackoverflow%.com', kind = 'url' },
        steam = { icon = '', pattern = 'steampowered%.com', kind = 'url' },
        twitter = { icon = '', pattern = 'twitter%.com', kind = 'url' },
        wikipedia = { icon = '', pattern = 'wikipedia%.org', kind = 'url' },
        x = { icon = '', pattern = 'x%.com', kind = 'url' },
        youtube = { icon = '', pattern = 'youtube[^.]*%.com', kind = 'url' },
        youtube_short = { icon = '', pattern = 'youtu%.be', kind = 'url' },
      },
    },

    pipe_table = { preset = 'round' },
    quote = { repeat_linebreak = true },
    win_options = {
      wrap = {
        default = vim.o.wrap,
        rendered = true,
      },
      linebreak = {
        default = vim.o.linebreak,
        rendered = true,
      },
      showbreak = {
        default = '',
        rendered = '  ',
      },
      breakindent = {
        default = false,
        rendered = true,
      },
      breakindentopt = {
        default = '',
        rendered = '',
      },
    },
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
    vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { fg = '#888e99' })
    -- Blockquotes
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote1', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote2', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote3', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote4', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote5', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote6', { fg = '#7e9dbc' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownInlineHighlight', { bg = '#7e7026', fg = '#d3d8e3' })

    -- 1. Basis-Treesitter-Gruppe (greift bei Standard-Links): Blau und unterstrichen
    vim.api.nvim_set_hl(0, '@markup.link.label.markdown_inline', { fg = '#81a1c1', underline = true })
    -- (Optional) Falls die URL selbst auch betroffen sein soll:
    vim.api.nvim_set_hl(0, '@markup.link.markdown_inline', { fg = '#81a1c1', underline = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownLinkTitle', { fg = '#81a1c1', underline = true })
    -- 2. Wiki-Links: Blau und NICHT unterstrichen
    -- 'nocombine = true' blockiert das Erben der Unterstreichung aus der Treesitter-Basis
    vim.api.nvim_set_hl(0, 'my-link', { fg = '#81a1c1', underline = false, nocombine = true })
    -- Das Icon davor (falls aktiv)
    vim.api.nvim_set_hl(0, 'RenderMarkdownLink', { fg = '#81a1c1', underline = false })
  end,
  ft = { 'markdown' },
}
