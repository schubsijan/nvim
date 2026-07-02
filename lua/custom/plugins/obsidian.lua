return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = "masterarbeit",
        path = "/home/schubsi/Dokumente/Studium/Masterarbeit/masterarbeit-obsidian",
      },
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)
    vim.opt_local.conceallevel = 2
  end
}
