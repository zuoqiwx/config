-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = vim.keymap.set

-- Escape
map('i', 'jj', '<Esc>', { noremap = true, desc = 'Escape insert mode' })

-- Better up/down (respect wrapped lines)
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better search navigation
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Better page navigation
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Window navigation (handled by vim-tmux-navigator via C-h/j/k/l)

-- Resize windows with Alt
map('n', '<M-h>', '<cmd>resize -5<cr>', { desc = 'Decrease window height' })
map('n', '<M-j>', '<cmd>resize +5<cr>', { desc = 'Increase window height' })
map('n', '<M-k>', '<cmd>vertical resize -5<cr>', { desc = 'Decrease window width' })
map('n', '<M-l>', '<cmd>vertical resize +5<cr>', { desc = 'Decrease window width' })

-- Move lines
map('n', '<A-Down>', '<cmd>m .+1<cr>', { desc = 'Move line down' })
map('n', '<A-Up>', '<cmd>m .-2<cr>', { desc = 'Move line up' })
map('v', '<A-Down>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-Up>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Clear search highlight
map({ 'i', 'n' }, '<Esc>', '<cmd>nohlsearch<cr><Esc>', { desc = 'Clear hlsearch' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Save
map({ 'i', 'n', 'x', 's' }, '<C-s>', '<cmd>w<cr><Esc>', { desc = 'Save file' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Windows
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete window' })
map('n', '<leader>ws', '<C-W>s', { desc = 'Split below' })
map('n', '<leader>wv', '<C-W>v', { desc = 'Split right' })

-- Tabs
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })

-- Diagnostic (supplement 0.12 defaults)
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>cl', '<cmd>checkhealth vim.lsp<cr>', { desc = 'LSP info' })

-- fzf-lua (lazy-loaded: first call triggers packadd)
local function fzf(method, opts)
  return function()
    if not package.loaded['fzf-lua'] then
      vim.cmd.packadd('fzf-lua')
    end
    require('fzf-lua')[method](opts)
  end
end
map('n', '<leader>ff', fzf('files'), { desc = 'Find files' }) 
map('n', '<leader>fg', fzf('live_grep'), { desc = 'Live grep' }) 
map('n', '<leader>fb', fzf('buffers'), { desc = 'Buffers' }) 
map('n', '<leader>fh', fzf('help_tags'), { desc = 'Help tags' }) 
map('n', '<leader>fr', fzf('oldfiles'), { desc = 'Recent files' }) 
map('n', '<leader>fw', fzf('grep_cword'), { desc = 'Grep word' }) 
map('n', '<leader>fd', fzf('diagnostics_document'), { desc = 'Document diagnostics' }) 
map('n', '<leader>fD', fzf('diagnostics_workspace'), { desc = 'Workspace diagnostics' }) 
map('n', '<leader>fs', fzf('lsp_document_symbols'), { desc = 'Document symbols' }) 
map('n', '<leader>fS', fzf('lsp_workspace_symbols'), { desc = 'Workspace symbols' }) 
map('n', '<leader>/', fzf('live_grep'), { desc = 'Grep (root dir)' }) 
map('n', '<leader>,', fzf('files'), { desc = 'Switch buffer' }) 
map('n', '<leader><space>', fzf('files'), { desc = 'Find files' })

-- Oil file explorer
local function find_oil_float()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[win].is_oil_win then
      return win
    end
  end
end

-- Directory to open: the current file's folder, the current oil dir, or cwd.
local function oil_target_dir()
  if vim.bo.filetype == 'oil' then
    return require('oil').get_current_dir() or vim.fn.getcwd()
  end
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= '' and vim.fn.filereadable(name) == 1 then
    return vim.fn.fnamemodify(name, ':p:h')
  end
  return vim.fn.getcwd()
end

map('n', '<leader>fe', function()
  local win = find_oil_float()
  if win then
    vim.api.nvim_win_close(win, true)
    return
  end
  require('oil').open_float(oil_target_dir())
end, { desc = 'File explorer (Oil, floating)' })

map('n', '-', function()
  require('oil').open()
end, { desc = 'Open parent directory' })

map({ 'n', 'v' }, '<leader>cf', function()
  if not package.loaded['conform'] then
    vim.cmd.packadd('conform.nvim')
    require('plugins.format')
  end
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format' })

-- Floating terminals (gh-dash, lazygit) via the shared float_term helper.
local float_term = require('float_term')

map('n', '<leader>gt', function()
  float_term.toggle('ghdash', { 'gh', 'dash' })
end, { desc = 'GitHub Dashboard (gh-dash, floating)' })

map('n', '<leader>gg', function()
  float_term.toggle('lazygit', { 'lazygit' })
end, { desc = 'Lazygit (floating)' })
