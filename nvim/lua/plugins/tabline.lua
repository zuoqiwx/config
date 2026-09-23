-- lua/plugins/tabline.lua - bufferline.nvim config
-- File icons come from mini.icons via MiniIcons.mock_nvim_web_devicons() in plugins/ui.lua
require("bufferline").setup({
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = true,
		show_close_icon = false,
		separator_style = "thick",
		offsets = {
			{
				filetype = "oil",
				text = "Oil",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})
