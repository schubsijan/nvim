return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP (unten rechts)
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    local nvim_lsp = require 'lspconfig'
    -- Format on save.
    -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

    -- map('[d', vim.diagnostic.goto_prev, 'go to previous diagnostic')
    -- map(']d', vim.diagnostic.goto_next, 'go to next diagnostic')nvim_buf_set_keymap
    -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local opts = function(desc)
        return { noremap = true, silent = true, desc = 'LSP: ' .. desc, buffer = bufnr }
      end
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, opts(desc))
      end
      map('<leader>d', vim.diagnostic.open_float, 'show [d]iagnostics for line')

      local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
      end

      --Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')
      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      -- Find references for the word under your cursor.
      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    end

    -- Add templ configuration.
    vim.filetype.add { extension = { templ = 'templ' } }
    local configs = require 'lspconfig.configs'
    configs.templ = {
      default_config = {
        --cmd = { "templ", "lsp", "-http=localhost:7474", "-log=/Users/adrian/templ.log", "-goplsLog=/Users/adrian/gopls.log" },
        cmd = { 'templ', 'lsp' },
        filetypes = { 'templ' },
        root_dir = nvim_lsp.util.root_pattern('go.mod', '.git'),
        settings = {},
      },
    }

    -- add capabilities of Autocompletion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local server_settings = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      gopls = {
        filetypes = { 'go', 'templ' },
      },
      eslint = {
        enable = true,
        format = { enable = true }, -- this will enable formatting
        packageManager = 'npm',
        autoFixOnSave = true,
        codeActionOnSave = {
          mode = 'all',
          rules = { '!debugger', '!no-only-tests/*' },
        },
        lintTask = {
          enable = true,
        },
      },
      html = {
        filetypes = { 'html', 'templ' },
      },
      templ = {},
      tailwindcss = {
        filetypes = { 'templ', 'html' },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = 'html',
            },
          },
        },
      },
    }

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    -- eslint comes from:
    -- npm i -g vscode-langservers-extracted
    local servers = { 'gopls', 'templ', 'eslint', 'lua_ls', 'html' }
    for _, lsp in ipairs(servers) do
      local lsp_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
      if server_settings[lsp] then
        lsp_opts.settings = server_settings[lsp]
      end
      nvim_lsp[lsp].setup(lsp_opts)
    end
  end,
}

--[[
return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP (unten rechts)
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        map('<leader>d', vim.diagnostic.open_float, 'show [d]iagnostics for line')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints of LSP')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- besser Icons wenn LSP Fehler findet
    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},
      --

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      templ = {},
      html = {
        filetypes = { 'html', 'templ' },
      },
      tailwindcss = {
        filetypes = { 'templ', 'html' },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = 'html',
            },
          },
        },
      },
      gopls = {
        filetypes = { 'go', 'templ' },
      },
    }
    -- adding Templ zu meinen filetypes, sodass LSP diesen filetype erkennen
    vim.filetype.add { extension = { templ = 'templ' } }
    -- formatierung für templ
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

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}

]]
