-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

vim.filetype.add { extension = { templ = 'templ' } }

local function setup_templ()
  local lspconfig = require 'lspconfig'

  lspconfig.html.setup {
    capabilities = capabilities,
    filetypes = { 'html', 'templ' },
  }
  lspconfig.tailwindcss.setup {
    capabilities = capabilities,
    filetypes = { 'templ', 'astro', 'javascript', 'typescript', 'react' },
    settings = {
      tailwindCSS = {
        includeLanguages = {
          templ = 'html',
        },
      },
    },
  }

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches

  local servers = { 'gopls', 'templ' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      capabilities = capabilities,
    }
  end
  local custom_format = function()
    if vim.bo.filetype == 'templ' then
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local cmd = 'templ fmt ' .. vim.fn.shellescape(filename)

      vim.fn.jobstart(cmd, {
        on_exit = function()
          -- Reload the buffer only if it's still the current buffer
          if vim.api.nvim_get_current_buf() == bufnr then
            vim.cmd 'e!'
          end
        end,
      })
    else
      vim.lsp.buf.format()
    end
  end
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = custom_format })
end

setup_templ()
