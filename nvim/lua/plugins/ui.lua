-- lua/plugins/ui.lua — mini.nvim modules setup
-- mini.nvim is already packadd'd in init.lua before this runs

-- Icons (dependency for which-key, lualine, oil)
require('mini.icons').setup()
-- Make mini.icons the default provider (replaces nvim-web-devicons)
MiniIcons.mock_nvim_web_devicons()

-- Enhanced text objects (around/inside)
require('mini.ai').setup({
  n_lines = 500,
  custom_textobjects = {
    o = require('mini.ai').gen_spec.treesitter({
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }),
    f = require('mini.ai').gen_spec.treesitter({
      a = '@function.outer',
      i = '@function.inner',
    }),
    c = require('mini.ai').gen_spec.treesitter({
      a = '@class.outer',
      i = '@class.inner',
    }),
  },
})

-- Auto-pairs
require('mini.pairs').setup({
  modes = { insert = true, command = false, terminal = false },
})

-- Surround (sa=add, sd=delete, sr=replace)
require('mini.surround').setup({
  mappings = {
    add = 'sa',
    delete = 'sd',
    find = 'sf',
    find_left = 'sF',
    highlight = 'sh',
    replace = 'sr',
    update_n_lines = 'sn',
  },
})
