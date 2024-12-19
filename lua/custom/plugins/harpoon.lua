-- Ui & Shortcuts, um einfach zwischen Dateien zu wechsenl
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}
    vim.keymap.set('n', '<leader>h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'open harpoon window' })
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = 'add file to harpoon-list' })
    vim.keymap.set('n', '<leader>p', function()
      harpoon:list():prev()
    end, { desc = 'switch with harpoon to previous File on List' })
    vim.keymap.set('n', '<leader>n', function()
      harpoon:list():next()
    end, { desc = 'switch with harpoon to next File on List' })
  end,
}
