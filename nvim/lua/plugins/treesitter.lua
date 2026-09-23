-- lua/plugins/treesitter.lua - nvim-treesitter (`main` branch) config
local langs = {
  'bash',
  'c',
  'javascript',
  'typescript',
  'tsx',
  'json',
  'yaml',
  'html',
  'css',
  'markdown',
  'markdown_inline',
  'lua',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'vim',
  'vimdoc',
  'regex',
}

-- Install parsers + queries (async; no-op if already present)
require('nvim-treesitter').install(langs)

-- Highlighting is not auto-enabled on `main`; start it per buffer.
local max_filesize = 100 * 1024
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts-highlight', { clear = true }),
  callback = function()
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return
    end
    pcall(vim.treesitter.start)
  end,
})

-- Treesitter-based indentation (experimental, opt-in on `main`)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ts-indent', { clear = true }),
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- nvim-ts-autotag (already packadd'd in init.lua)
require('nvim-ts-autotag').setup()
