-- lua/plugins/git.lua - gitsigns.nvim config
require('gitsigns').setup({
  signs = {
    add = { text = '|' },
    change = { text = '|' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '|' },
  },
  signs_staged = {
    add = { text = '|' },
    change = { text = '|' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(buf)
    local gs = require('gitsigns')
    local map = vim.keymap.set

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, { buffer = buf, desc = 'Next hunk' })

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, { buffer = buf, desc = 'Prev hunk' })

    -- Actions
    map('n', '<Leader>ghs', gs.stage_hunk, { buffer = buf, desc = 'Stage hunk' })
    map('n', '<Leader>ghr', gs.reset_hunk, { buffer = buf, desc = 'Reset hunk' })
    map('v', '<Leader>ghs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buffer = buf, desc = 'Stage hunk' })
    map('v', '<Leader>ghr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buffer = buf, desc = 'Reset hunk' })
    map('n', '<Leader>ghS', gs.stage_buffer, { buffer = buf, desc = 'Stage buffer' })
    map('n', '<Leader>ghu', gs.undo_stage_hunk, { buffer = buf, desc = 'Undo stage hunk' })
    map('n', '<Leader>ghR', gs.reset_buffer, { buffer = buf, desc = 'Reset buffer' })
    map('n', '<Leader>ghp', gs.preview_hunk_inline, { buffer = buf, desc = 'Preview hunk inline' })
    map('n', '<Leader>ghb', function()
      gs.blame_line({ full = true })
    end, { buffer = buf, desc = 'Blame line' })
    map('n', '<Leader>ghd', gs.diffthis, { buffer = buf, desc = 'Diff this' })

    -- Toggle
    map('n', '<Leader>gb', gs.toggle_current_line_blame, { buffer = buf, desc = 'Toggle line blame' })

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = buf, desc = 'Select hunk' })
  end,
})
