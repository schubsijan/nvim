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
                    end_row = row,
                    end_col = pos - 1 + #pat,
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
        rendered = ' ',
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
    local function hl(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    local function pick(groups, attr)
      for _, name in ipairs(groups) do
        local h = hl(name)
        if h[attr] then
          return h[attr]
        end
      end
      return nil
    end

    local function setup_highlights()
      local normal_bg = hl('Normal').bg

      local heading_sources = {
        H1 = { '@markup.heading.1.markdown', 'Title' },
        H2 = { '@markup.heading.2.markdown', 'Identifier' },
        H3 = { '@markup.heading.3.markdown', 'Special' },
        H4 = { '@markup.heading.4.markdown', 'Statement' },
        H5 = { '@markup.heading.5.markdown', '@markup.heading', 'NonText' },
        H6 = { '@markup.heading.6.markdown', '@markup.heading', 'Comment' },
      }
      for level, sources in pairs(heading_sources) do
        local fg = pick(sources, 'fg')
        if fg then
          vim.api.nvim_set_hl(0, 'RenderMarkdown' .. level, { fg = fg })
          vim.api.nvim_set_hl(0, 'RenderMarkdown' .. level .. 'Bg', { fg = fg, bg = normal_bg })
        end
      end

      local italic_fg = pick({ '@markup.italic', 'Type' }, 'fg')
      if italic_fg then
        vim.api.nvim_set_hl(0, '@markup.italic', { fg = italic_fg, italic = true })
      end

      local bullet_fg = pick({ 'NonText', 'Comment' }, 'fg')
      if bullet_fg then
        vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { fg = bullet_fg })
      end

      local quote_fg = pick({ '@markup.quote', 'String', 'Comment' }, 'fg')
      if quote_fg then
        for i = 1, 6 do
          vim.api.nvim_set_hl(0, 'RenderMarkdownQuote' .. i, { fg = quote_fg })
        end
      end

      vim.api.nvim_set_hl(0, 'RenderMarkdownInlineHighlight', {
        bg = pick({ 'Visual', 'CursorLine' }, 'bg') or normal_bg,
        fg = pick({ 'Visual', 'Normal' }, 'fg'),
      })

      local link_fg = pick({ '@markup.link', '@markup.link.markdown', '@string.special.url', 'Identifier' }, 'fg')
      if link_fg then
        vim.api.nvim_set_hl(0, '@markup.link.label.markdown_inline', { fg = link_fg, underline = true })
        vim.api.nvim_set_hl(0, '@markup.link.markdown_inline', { fg = link_fg, underline = true })
        vim.api.nvim_set_hl(0, 'RenderMarkdownLinkTitle', { fg = link_fg, underline = true })
        vim.api.nvim_set_hl(0, 'my-link', { fg = link_fg, underline = false, nocombine = true })
        vim.api.nvim_set_hl(0, 'RenderMarkdownLink', { fg = link_fg, underline = false })
      end
    end

    setup_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        vim.schedule(setup_highlights)
      end,
      desc = 'render-markdown: Highlights ans Colorscheme anpassen',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.bo.formatoptions = vim.bo.formatoptions .. 'r'
        vim.bo.comments = 'b:-,b:*,b:+,b:1.,b:1)'
        vim.bo.autoindent = true
      end,
      desc = 'markdown: Bullet-Listen auf Enter fortsetzen',
    })

    local orig_definition = vim.lsp.buf.definition
    function vim.lsp.buf.definition()
      if vim.tbl_contains({ 'markdown', 'pandoc', 'rmd' }, vim.bo.filetype) then
        local zotero = require 'custom.scripts.zotero'
        if zotero.open_in_zotero() then
          return
        end

        local line = vim.fn.getline('.')
        local col = vim.fn.col('.') - 1
        local pos = 1
        while pos <= #line do
          local link_start, link_end, url = line:find('%b[]%(([^)]+)%)', pos)
          if not link_start then break end
          if col >= link_start - 1 and col <= link_end - 1 then
            vim.fn.system({ 'xdg-open', url })
            return
          end
          pos = link_end + 1
        end
      end

      orig_definition()
    end
  end,
  ft = { 'markdown' },
}
