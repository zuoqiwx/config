-- lua/plugins/explorer.lua - oil.nvim config
-- Lazy-loaded via keymaps.lua and autocmds.lua
require('oil').setup({
  default_file_explorer = true,
  columns = {
    'icon',
    'size',
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 30,
    border = 'rounded',
  },
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['l'] = 'actions.select',
    ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-p>'] = 'actions.preview',
    ['q'] = 'actions.close',
    ['<Esc>'] = 'actions.close',
    ['h'] = 'actions.parent',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['gH'] = 'actions.toggle_hidden',
    ['g\\'] = 'actions.toggle_trash',
    -- Copy path to clipboard
    ['Y'] = {
      callback = function()
        local oil = require('oil')
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          vim.fn.setreg('+', path)
          vim.notify('Copied: ' .. path)
        end
      end,
      desc = 'Copy path to clipboard',
    },
  },
})
