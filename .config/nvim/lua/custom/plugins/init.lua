-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Seamless navigation between tmux panes and neovim splits
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    keys = {
      -- Navigation
      {
        '<C-h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
        desc = 'Move to left split/pane',
      },
      {
        '<C-j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
        desc = 'Move to below split/pane',
      },
      {
        '<C-k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
        desc = 'Move to above split/pane',
      },
      {
        '<C-l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
        desc = 'Move to right split/pane',
      },
      -- Resizing (Alt + hjkl)
      {
        '<A-h>',
        function()
          require('smart-splits').resize_left()
        end,
        desc = 'Resize split left',
      },
      {
        '<A-j>',
        function()
          require('smart-splits').resize_down()
        end,
        desc = 'Resize split down',
      },
      {
        '<A-k>',
        function()
          require('smart-splits').resize_up()
        end,
        desc = 'Resize split up',
      },
      {
        '<A-l>',
        function()
          require('smart-splits').resize_right()
        end,
        desc = 'Resize split right',
      },
      -- Swapping buffers between splits
      {
        '<leader>wh',
        function()
          require('smart-splits').swap_buf_left()
        end,
        desc = 'Swap buffer left',
      },
      {
        '<leader>wj',
        function()
          require('smart-splits').swap_buf_down()
        end,
        desc = 'Swap buffer down',
      },
      {
        '<leader>wk',
        function()
          require('smart-splits').swap_buf_up()
        end,
        desc = 'Swap buffer up',
      },
      {
        '<leader>wl',
        function()
          require('smart-splits').swap_buf_right()
        end,
        desc = 'Swap buffer right',
      },
    },
    opts = {
      ignored_filetypes = { 'nofile', 'quickfix', 'prompt' },
      ignored_buftypes = { 'NvimTree' },
      default_amount = 3,
      at_edge = 'wrap', -- or 'stop' if you don't want wrap-around
    },
  },

  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {}
    end,
  },

  -- TypeScript/JavaScript powertools (like rustaceanvim for TS)
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- specify commands for code actions
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'TS: ' .. desc })
        end
        -- TypeScript-specific keymaps (mirrors rustaceanvim pattern)
        map('<leader>to', '<CMD>TSToolsOrganizeImports<CR>', '[O]rganize imports')
        map('<leader>ts', '<CMD>TSToolsSortImports<CR>', '[S]ort imports')
        map('<leader>tu', '<CMD>TSToolsRemoveUnusedImports<CR>', 'Remove [U]nused imports')
        map('<leader>td', '<CMD>TSToolsGoToSourceDefinition<CR>', 'Go to source [D]efinition')
        map('<leader>tr', '<CMD>TSToolsRenameFile<CR>', '[R]ename file (updates imports)')
        map('<leader>tf', '<CMD>TSToolsFileReferences<CR>', '[F]ile references')
        map('<leader>ta', '<CMD>TSToolsAddMissingImports<CR>', '[A]dd missing imports')
        map('<leader>tx', '<CMD>TSToolsFixAll<CR>', 'Fi[x] all fixable errors')
      end,
    },
  },

  -- Rust development powertools
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = 'rounded',
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
            end
            -- Rust-specific keymaps
            map('<leader>re', function()
              vim.cmd.RustLsp 'expandMacro'
            end, '[E]xpand macro')
            map('<leader>rc', function()
              vim.cmd.RustLsp 'openCargo'
            end, 'Open [C]argo.toml')
            map('<leader>rp', function()
              vim.cmd.RustLsp 'parentModule'
            end, '[P]arent module')
            map('<leader>rr', function()
              vim.cmd.RustLsp 'runnables'
            end, '[R]unnables')
            map('<leader>rd', function()
              vim.cmd.RustLsp 'debuggables'
            end, '[D]ebuggables')
            map('<leader>rt', function()
              vim.cmd.RustLsp 'testables'
            end, '[T]estables')
            map('<leader>rm', function()
              vim.cmd.RustLsp 'rebuildProcMacros'
            end, 'Rebuild proc [M]acros')
            map('<leader>rk', function()
              vim.cmd.RustLsp { 'moveItem', 'up' }
            end, 'Move item up')
            map('<leader>rj', function()
              vim.cmd.RustLsp { 'moveItem', 'down' }
            end, 'Move item down')
            map('<leader>ra', function()
              vim.cmd.RustLsp 'codeAction'
            end, 'Code [A]ction')
            map('<leader>rh', function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end, '[H]over actions')
            map('J', function()
              vim.cmd.RustLsp 'joinLines'
            end, 'Join lines')
            map('<leader>rE', function()
              vim.cmd.RustLsp 'explainError'
            end, '[E]xplain error')
            map('<leader>rD', function()
              vim.cmd.RustLsp 'renderDiagnostic'
            end, 'Render [D]iagnostic')
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = true,
              check = { command = 'clippy' },
              procMacro = {
                enable = true,
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['tokio'] = { 'main', 'test' },
                },
              },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml dependency management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    tag = 'stable',
    config = function()
      local crates = require 'crates'
      crates.setup {
        -- No cmp integration since we use blink.cmp
        completion = {
          cmp = { enabled = false },
        },
      }
      -- Keymaps for Cargo.toml
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = 'Cargo.toml',
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'Crates: ' .. desc })
          end
          map('<leader>ct', crates.toggle, '[T]oggle crates info')
          map('<leader>cr', crates.reload, '[R]eload crates')
          map('<leader>cv', crates.show_versions_popup, '[V]ersions popup')
          map('<leader>cf', crates.show_features_popup, '[F]eatures popup')
          map('<leader>cd', crates.show_dependencies_popup, '[D]ependencies popup')
          map('<leader>cu', crates.update_crate, '[U]pdate crate')
          map('<leader>cU', crates.upgrade_crate, '[U]pgrade crate')
          map('<leader>ca', crates.update_all_crates, 'Update [A]ll crates')
          map('<leader>cA', crates.upgrade_all_crates, 'Upgrade [A]ll crates')
          map('<leader>cH', crates.open_homepage, 'Open [H]omepage')
          map('<leader>cR', crates.open_repository, 'Open [R]epository')
          map('<leader>cD', crates.open_documentation, 'Open [D]ocs.rs')
          map('<leader>cC', crates.open_crates_io, 'Open [C]rates.io')
        end,
      })
    end,
  },
  -- Toggle terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', '<CMD>ToggleTerm<CR>', desc = 'Toggle terminal' },
      { '<C-\\>', '<CMD>ToggleTerm<CR>', mode = 't', desc = 'Toggle terminal' },
    },
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        width = function()
          return math.floor(vim.o.columns * 0.85)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
      shade_terminals = true,
    },
  },


  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      filetypes = { '*' },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false, -- "Blue" etc - disabled for perf
        RRGGBBAA = true, -- #RRGGBBAA
        AARRGGBB = true, -- 0xAARRGGBB
        rgb_fn = true, -- CSS rgb()
        hsl_fn = true, -- CSS hsl()
        css = true,
        css_fn = true,
        mode = 'virtualtext', -- "background", "foreground", or "virtualtext"
        virtualtext = '■',
        virtualtext_inline = true,
        always_update = false,
      },
    },
  },

}
