-- lua/plugins/noice.lua - floating cmdline / messages UI
require('noice').setup({
  cmdline = {
    enabled = true,
    view = 'cmdline_popup',
  },
  -- blink.cmp owns the completion popup; don't let noice render it too
  popupmenu = {
    enabled = false,
  },
  messages = {
    enabled = true,
    view = 'notify',
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
})
