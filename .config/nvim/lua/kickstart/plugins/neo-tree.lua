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
