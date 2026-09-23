local opt = vim.opt

-- Disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows mode
-- opt.laststatus = 3 -- global statusline
opt.pumheight = 10 -- popup menu height
opt.pumblend = 10 -- popup menu transparency
opt.colorcolumn = '100' -- show a column at position
opt.cmdheight = 0 -- hidden; noice.nvim renders the cmdline as a float
opt.winblend = 0 -- floating window transparency
opt.winminwidth = 5
opt.conceallevel = 0 -- do not hide markup
opt.concealcursor = '' -- do not hide cursorline in markup
opt.synmaxcol = 300 -- syntax highlighting limit

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.shiftround = true
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true -- show matches as you type
opt.showmatch = true

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'

-- Clipboard
opt.clipboard:append('unnamedplus') -- use system clipboard

-- Undo
local undodir = vim.fn.expand('~/.vim/undodir')
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
opt.undofile = true
opt.undodir = undodir
opt.undolevels = 10000

-- Completion (native + blink.cmp)
opt.completeopt = 'menu,menuone,noselect,fuzzy,popup' -- completion options

-- Scroll
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.smoothscroll = true

-- Fill chars
opt.fillchars = {
  foldopen = ' ',
  foldclose = ' ',
  fold = ' ',
  foldsep = ' ',
  diff = '/',
  eob = ' '
}

-- Fold
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99 -- start with all folds open

-- Misc
opt.confirm = true
opt.mouse = 'a' -- enable mouse support
opt.updatetime = 200
opt.timeoutlen = 300
opt.virtualedit = 'block'
opt.wildmenu = true -- tab completion
opt.wildmode = 'longest:full,full' -- complete longest common match, full completion list, cycle through with tab
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.ttimeoutlen = 0
opt.autoread = true
opt.autowrite = false
opt.hidden = true -- allow hidden buffers
opt.errorbells = false
opt.backspace = 'indent,eol,start' -- better backspace behaviour
opt.autochdir = false -- do not autochange directory
opt.iskeyword:append('-') -- include - in words
opt.path:append('**') -- include subdirs in search
opt.selection = 'inclusive' -- include last char in selection
opt.modifiable = true -- allow buffer modification
opt.encoding = 'UTF-8'
opt.diffopt:append('linematch:60') -- improve diff display
opt.redrawtime = 10000 -- increase neovim redraw tolerance
opt.maxmempattern = 20000 -- increase max memory

-- Grep
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

-- Disabled built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor = 1
vim.g.loaded_zipPlugin = 1
