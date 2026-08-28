return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'vrischmann/tree-sitter-templ',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.config').setup({
        ensure_installed = { 'svelte', 'typescript', 'javascript', 'html', 'css' },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'svelte' },
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
