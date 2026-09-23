-- lua/autocmds.lua - Autocommands, lazy-load triggers, PackChanged hooks

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- PackChanged hooks (build steps for plugins)
----------------------------------------------------------------
autocmd({ "User" }, {
	pattern = "PackChanged",
	group = augroup("pack-hooks", { clear = true }),
	callback = function(ev)
		local spec = ev.data and ev.data.spec
		if not spec then
			return
		end
		local kind = ev.data.kind -- "install" / "update" / "delete"

		-- Treesitter: run :TSUpdate after install/update
		if spec.name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			vim.cmd("TSUpdate")
		end

		-- blink.cmp: build step if needed
		if spec.name == "blink.cmp" and (kind == "install" or kind == "update") then
			local path = ev.data.path
			if path and vim.fn.filereadable(path .. "/build.lua") == 1 then
				vim.cmd("source " .. path .. "/build.lua")
			end
		end
	end,
})

-- lazy-load triggers
----------------------------------------------------------------

-- which-key: load after UI is ready (deferred)
autocmd("UIEnter", {
	group = augroup("lazy-which-key", { clear = true }),
	once = true,
	callback = vim.schedule_wrap(function()
		vim.cmd.packadd("which-key.nvim")
		require("which-key").setup({
			preset = "helix",
			delay = function(ctx)
				return ctx.plugin and 0 or 200
			end,
			icons = {
				mappings = true,
			},
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "find/file" },
				{ "<leader>g", group = "git" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>w", group = "windows" },
				{ "<leader><tab>", group = "tabs" },
			},
		})
	end),
})

-- conform.nvim: load on BufWritePre for format-on-save
autocmd("BufWritePre", {
	group = augroup("lazy-conform", { clear = true }),
	callback = function(ev)
		if not package.loaded["conform"] then
			vim.cmd.packadd("conform.nvim")
		end
		require("plugins.format")
		require("conform").format({ bufnr = ev.buf, lsp_fallback = true, timeout_ms = 3000 })
	end,
})

-- render-markdown: load on markdown FileType
autocmd("FileType", {
	group = augroup("lazy-render-markdown", { clear = true }),
	pattern = { "markdown", "quarto", "rmd" },
	once = true,
	callback = function()
		vim.cmd.packadd("render-markdown.nvim")
		require("plugins.markdown")
		-- Re-trigger FileType so the plugin attaches to this buffer
		vim.cmd("doautocmd FileType")
	end,
})

-- fzf-lua: also lazy-load on :FzfLua command
autocmd("CmdUndefined", {
	group = augroup("lazy-fzf", { clear = true }),
	pattern = "FzfLua",
	once = true,
	callback = function()
		vim.cmd.packadd("fzf-lua")
		require("plugins.finder")
	end,
})

----------------------------------------------------------------
-- General autocmds
----------------------------------------------------------------

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Resize splits on window resize
autocmd("VimResized", {
	group = augroup("resize-splits", { clear = true }),
	command = "tabdo wincmd =",
})

-- Go to last cursor position when opening a buffer
autocmd("BufReadPost", {
	group = augroup("last-loc", { clear = true }),
	callback = function(ev)
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(ev.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
	group = augroup("close-with-q", { clear = true }),
	pattern = { "help", "lspinfo", "notify", "qf", "checkhealth", "man" },
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
	end,
})

-- Auto-create parent dirs on save
autocmd("BufWritePre", {
	group = augroup("auto-create-dir", { clear = true }),
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Check if file changed outside of nvim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})
