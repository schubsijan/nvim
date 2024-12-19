return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'golines' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
    config = function()
      --[[
      -- Formatierung für .templ files
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, { -- IDK the docs said to do the format before saving the file, but it only makes the formatter freak out.
        pattern = { '*.templ' },
        callback = function()
          local file_name = vim.api.nvim_buf_get_name(0) -- Get file name of file in current buffer
          vim.cmd(':silent !templ fmt ' .. file_name)

          local bufnr = vim.api.nvim_get_current_buf()
          if vim.api.nvim_get_current_buf() == bufnr then
            vim.cmd 'e!'
          end
        end,
      })]]
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
