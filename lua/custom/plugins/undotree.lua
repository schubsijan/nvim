return {
  'mbbill/undotree',
  config = function()
    -- setting the right command for usage on windows
    vim.g.undotree_DiffCommand = 'FC'
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'toggle Undotree' })
    -- undotree erlauben auch noch nach langer Zeit Dinge zu löschen
    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undodir = os.getenv 'UserProfile' .. '/.vim/undodir'
    vim.opt.undofile = true
  end,
}
