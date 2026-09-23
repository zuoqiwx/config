-- lua/plugins/format.lua - conform.nvim config
-- Lazy-loaded via autocmds.lua BufWritePre and keymaps.lua <leader>cf
require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    lua = { 'stylua' },
    go = { 'gofmt' },
  },
  -- Format on save is handled by autocmds.lua BufWritePre
  format_on_save = false, -- We handle this in autocmds.lua
})
