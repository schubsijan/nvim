return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'masterarbeit',
        path = '/home/schubsi/Dokumente/Studium/Masterarbeit/masterarbeit-obsidian',
      },
    },
    frontmatter = { enabled = false },
    legacy_commands = false,
    footer = {
      format = '{{backlinks}} backlinks',
    },
  },
  config = function(_, opts)
    require('obsidian').setup(opts)
    vim.api.nvim_set_hl(0, 'WinBarTitle', { fg = '#bf616a', bold = true })
    vim.opt_local.conceallevel = 2
    vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian backlinks<cr>', { desc = 'Backlinks' })

    local vault_path = opts.workspaces[1].path

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('obsidian-gd', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local filepath = vim.api.nvim_buf_get_name(buf)
        if not filepath:find(vault_path, 1, true) then return end
        vim.keymap.set('n', 'gd', function()
          local word = vim.fn.expand '<cWORD>'
          if word:sub(1, 1) == '#' then
            vim.cmd('Obsidian tags ' .. word:sub(2))
          else
            vim.lsp.buf.definition()
          end
        end, { buffer = buf, desc = 'Go to definition or tag' })
      end,
    })

    vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
      pattern = 'markdown',
      callback = function(args)
        local buf = args.buf
        if not vim.api.nvim_buf_is_valid(buf) then return end
        local filepath = vim.api.nvim_buf_get_name(buf)
        if filepath:find(vault_path, 1, true) then
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            vim.wo[win].cursorline = false
            vim.wo[win].concealcursor = 'n'
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
            vim.wo[win].winbar = '%#WinBarTitle# ' .. vim.fn.fnamemodify(filepath, ':t:r') .. ' %*'
          end
        end
      end,
    })
  end,
}
