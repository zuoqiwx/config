vim.opt.termguicolors = true

-- ========================================
-- OPTIONS
-- ========================================
require("options")

-- ========================================
-- PLUGINS
-- ========================================
vim.pack.add({
	-- 1. Colorscheme
	{
		src = "https://github.com/folke/tokyonight.nvim",
		name = "tokyonight.nvim",
	},
	-- 2. Treesitter
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		name = "nvim-treesitter",
	},
	-- 3. Git signs
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		name = "gitsigns.nvim",
	},
	-- 4. Fuzzy finder (lazy-loaded via keymaps)
	{
		src = "https://github.com/ibhagwan/fzf-lua",
		name = "fzf-lua",
	},
	-- 5. Formatting (lazy-loaded via BufWritePre)
	{
		src = "https://github.com/stevearc/conform.nvim",
		name = "conform.nvim",
	},
	-- 6. File explorer (lazy-loaded via keymap)
	{
		src = "https://github.com/stevearc/oil.nvim",
		name = "oil.nvim",
	},
	-- 7. Tmux navigation
	{
		src = "https://github.com/christoomey/vim-tmux-navigator",
		name = "vim-tmux-navigator",
	},
	-- 8. HTML/JSX auto-close tags
	{
		src = "https://github.com/windwp/nvim-ts-autotag",
		name = "nvim-ts-autotag",
	},
	-- 9. Markdown rendering (lazy-loaded via FileType)
	{
		src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
		name = "render-markdown.nvim",
	},
	-- 10. Statusline
	{
		src = "https://github.com/nvim-lualine/lualine.nvim",
		name = "lualine.nvim",
	},
	-- 11. Keymap discovery (lazy-loaded via UIEnter)
	{
		src = "https://github.com/folke/which-key.nvim",
		name = "which-key.nvim",
	},
	-- 12. Mini.nvim (full module: icons, ai, pairs, surround)
	{
		src = "https://github.com/echasnovski/mini.nvim",
		name = "mini.nvim",
	},
	-- 13. Completion engine (pinned to v1)
	{
		src = "https://github.com/Saghen/blink.cmp",
		name = "blink.cmp",
		version = vim.version.range(">=1.0.0, <2.0.0"),
	},
	-- 14. Treesitter textobjects (provides queries/*/textobjects.scm for mini.ai)
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		name = "nvim-treesitter-textobjects",
	},
	-- 15. Buffer tabline
	{
		src = "https://github.com/akinsho/bufferline.nvim",
		name = "bufferline.nvim",
	},
	-- 16. UI component library (noice.nvim dependency)
	{
		src = "https://github.com/MunifTanjim/nui.nvim",
		name = "nui.nvim",
	},
	-- 17. Floating cmdline / messages UI
	{
		src = "https://github.com/folke/noice.nvim",
		name = "noice.nvim",
	},
}, { load = false }) -- Don't auto-load; we control load order below

-- ========================================
-- PLUGIN LOAD ORDER
-- ========================================
-- Immediate loads (need to be active at startup)
local immediate = {
	"tokyonight.nvim",
	"mini.nvim",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-autotag",
	"gitsigns.nvim",
	"vim-tmux-navigator",
	"lualine.nvim",
	"blink.cmp",
	"bufferline.nvim",
	"nui.nvim",
	"noice.nvim",
	"oil.nvim",
}
for _, name in ipairs(immediate) do
	vim.cmd.packadd(name)
end
-- Color scheme (must be after packadd)
vim.cmd.colorscheme("tokyonight")
-- Load plugin configs
require("plugins.ui")
require("plugins.treesitter")
require("plugins.completion")
require("plugins.git")
require("plugins.statusline")
require("plugins.tabline")
require("plugins.noice")
require("plugins.explorer")
require("plugins.navigation")
-- Load core config
require("keymaps")
require("autocmds")
require("diagnostics")

-- ========================================
-- LSP - Native 0,12 config
-- ========================================
-- Server configs live in lsp/*.lua (auto-discovered by nvim)
-- Enable servers here
vim.lsp.enable({
	"vtsls",
	"lua_ls",
	"gopls",
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		-- Enable inlay hints
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })
		end

		-- TS-specific keymaps
		if client.name == "vtsls" then
			require("plugins.typescript").on_attach(buf, client)
		end
	end,
})
