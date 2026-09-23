-- lua/plugins/navigation.lua - vim-tmux-navigator config
-- Plugin loaded via packadd in init.lua; keymaps set by plugin automatically.
-- These are the default C-h/j/k/l bindings provided by vim-tmux-navigator.

-- Disable default mappings so we can set them explicitly
vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { silent = true, desc = 'Navigate left (tmux)' })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { silent = true, desc = 'Navigate down (tmux)' })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { silent = true, desc = 'Navigate up (tmux)' })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { silent = true, desc = 'Navigate right (tmux)' })
vim.keymap.set('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', { silent = true, desc = 'Navigate previous (tmux)' })
