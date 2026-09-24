-- lua/plugins/terminal.lua - bottom terminal via snacks.nvim
-- Lazy-loaded via keymaps.lua; keeps the shell alive when hidden.
local M = {}

local did_setup = false

local function ensure()
	if did_setup then
		return
	end
	vim.cmd.packadd("snacks.nvim")
	require("snacks").setup({
		terminal = { win = { style = "terminal", position = "bottom" } },
	})
	did_setup = true
end

local function root()
	return vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
end

-- Focus-or-hide the root terminal: focused -> hide, otherwise show + focus.
function M.focus()
	ensure()
	require("snacks.terminal").focus(nil, { cwd = root() })
end

-- Toggle the root terminal (open/focus/hide).
function M.toggle_root()
	ensure()
	require("snacks.terminal").toggle(nil, { cwd = root() })
end

-- Toggle a terminal rooted at the current working directory.
function M.toggle_cwd()
	ensure()
	require("snacks.terminal").toggle()
end

return M
