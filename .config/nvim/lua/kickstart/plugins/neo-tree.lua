-- Neo-tree: VSCode-like file explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', '<CMD>Neotree toggle<CR>', desc = 'Toggle file explorer' },
    { '<leader>E', '<CMD>Neotree reveal<CR>', desc = 'Reveal current file' },
    { '<leader>ge', '<CMD>Neotree float git_status<CR>', desc = 'Git explorer' },
    { '<leader>be', '<CMD>Neotree float buffers<CR>', desc = 'Buffer explorer' },
  },
  config = function(_, opts)
    -- Set up vibrant Neo-tree highlights that work with Ayu
    local function set_neotree_highlights()
      local hl = vim.api.nvim_set_hl
      -- Base colors - make files readable, not faded
      hl(0, 'NeoTreeFileName', { fg = '#BFBDB6' }) -- Ayu foreground
      hl(0, 'NeoTreeDirectoryName', { fg = '#59C2FF', bold = true }) -- Bright blue dirs
      hl(0, 'NeoTreeDirectoryIcon', { fg = '#59C2FF' })
      hl(0, 'NeoTreeRootName', { fg = '#FFB454', bold = true, italic = true }) -- Orange root
      hl(0, 'NeoTreeFileNameOpened', { fg = '#E6B450', bold = true }) -- Gold for open files

      -- Git status colors that POP
      hl(0, 'NeoTreeGitAdded', { fg = '#7FD962' }) -- Bright green
      hl(0, 'NeoTreeGitConflict', { fg = '#FF3333', bold = true }) -- Red alert
      hl(0, 'NeoTreeGitDeleted', { fg = '#F07178' }) -- Soft red
      hl(0, 'NeoTreeGitIgnored', { fg = '#626A73' }) -- Dimmed but visible
      hl(0, 'NeoTreeGitModified', { fg = '#FFB454' }) -- Orange modified
      hl(0, 'NeoTreeGitUnstaged', { fg = '#E6B450' }) -- Yellow unstaged
      hl(0, 'NeoTreeGitUntracked', { fg = '#95E6CB' }) -- Cyan untracked
      hl(0, 'NeoTreeGitStaged', { fg = '#AAD94C', bold = true }) -- Lime staged

      -- UI elements
      hl(0, 'NeoTreeIndentMarker', { fg = '#3D424D' }) -- Subtle indent guides
      hl(0, 'NeoTreeExpander', { fg = '#626A73' })
      hl(0, 'NeoTreeModified', { fg = '#E6B450' }) -- Modified indicator
      hl(0, 'NeoTreeDimText', { fg = '#626A73' }) -- Dimmed text
      hl(0, 'NeoTreeFilterTerm', { fg = '#59C2FF', bold = true })
      hl(0, 'NeoTreeFloatBorder', { fg = '#3D424D' })
      hl(0, 'NeoTreeFloatTitle', { fg = '#E6B450', bold = true })
    end

    -- Apply highlights now and after colorscheme changes
    set_neotree_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('neotree-highlights', { clear = true }),
      callback = set_neotree_highlights,
    })

    require('neo-tree').setup(opts)
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = true,
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
        default = '',
        highlight = 'NeoTreeFileIcon',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true, -- Color names by git status
        highlight = 'NeoTreeFileName',
        highlight_opened_files = 'all', -- Highlight open files distinctly
      },
      modified = {
        symbol = '●',
        highlight = 'NeoTreeModified',
      },
      git_status = {
        symbols = {
          added = '',
          modified = '',
          deleted = '✖',
          renamed = '➜',
          untracked = '★',
          ignored = '◌',
          unstaged = '✗',
          staged = '✓',
          conflict = '',
        },
      },
    },
    window = {
      position = 'left',
      width = 35,
      mappings = {
        ['<space>'] = 'none', -- Don't conflict with leader
        ['<CR>'] = 'open',
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['<C-v>'] = 'open_vsplit',
        ['<C-s>'] = 'open_split',
        ['<C-t>'] = 'open_tabnew',
        ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['a'] = { 'add', config = { show_path = 'relative' } },
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = { 'copy', config = { show_path = 'relative' } },
        ['m'] = { 'move', config = { show_path = 'relative' } },
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
        ['.'] = 'toggle_hidden',
        ['/'] = 'fuzzy_finder',
        ['f'] = 'filter_on_submit',
        ['<C-x>'] = 'clear_filter',
        ['[g'] = 'prev_git_modified',
        [']g'] = 'next_git_modified',
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.git',
          '.DS_Store',
          'thumbs.db',
        },
        never_show = {
          '.DS_Store',
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      use_libuv_file_watcher = true,
    },
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      show_unloaded = true,
    },
    git_status = {
      window = {
        position = 'float',
      },
    },
  },
}
