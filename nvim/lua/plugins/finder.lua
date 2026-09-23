-- lua/plugins/finder.lua - fzf-lua config
-- Lazy-loaded via keymaps.lua and autocmds.lua
require('fzf-lua').setup({
  'default-title',
  fzf_colors = true,
  defaults = {
    formatter = 'path.filename_first',
  },
  winopts = {
    height = 0.85,
    width = 0.85,
    preview = {
      default = 'bat',
      horizontal = 'right:50%',
    },
  },
  keymap = {
    builtin = {
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
    fzf = {
      ['ctrl-c'] = 'abort',
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-u'] = 'half-page-up',
      ['ctrl-d'] = 'half-page-down',
    },
  },
  files = {
    cwd_prompt = false,
  },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096',
  },
})
