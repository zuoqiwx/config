-- lua/plugins/statusline.lua - lualine.nvim config
require("lualine").setup({
	options = {
		theme = "tokyonight",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
		component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
		section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{
				"diagnostics",
				symbols = {
					error = "\u{ea87} ",
					warn = "\u{ea6c} ",
					info = "\u{ea74} ",
					hint = "\u{ea61} ",
				},
			},
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, padding = { left = 0, right = 1 } },
		},
		lualine_x = {}, -- reserved for future
		lualine_y = {
			{
				"diff",
				symbols = { added = "\u{eadc} ", modified = "\u{eade} ", removed = "\u{eadf} " },
			},
		},
		lualine_z = {
			{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
	},
	extensions = { "lazy", "man", "oil", "quickfix" },
})
