-- lua/diagnostics.lua - diagnostic display config
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{ea87}",
			[vim.diagnostic.severity.WARN] = "\u{ea6c}",
			[vim.diagnostic.severity.INFO] = "\u{ea74}",
			[vim.diagnostic.severity.HINT] = "\u{ea61}",
		},
	},
	severity_sort = true,
	underline = true,
})
