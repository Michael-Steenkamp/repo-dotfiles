-- ============================================================
--  Wallust Live Theme Reloader
-- ============================================================
local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")

-- Helper: Reload Lualine with new colors
local function reload_lualine()
	if not package.loaded["lualine"] then
		return
	end

	-- Re-read the new global variables
	local c = {
		c0 = vim.g.color0 or "#000000",
		c1 = vim.g.color1 or "#cc5555",
		c2 = vim.g.color2 or "#55cc55",
		c3 = vim.g.color3 or "#d7ba7d",
		c4 = vim.g.color4 or "#5555cc",
		c5 = vim.g.color5 or "#cc55cc",
		c6 = vim.g.color6 or "#55cccc",
		c7 = vim.g.color7 or "#dddddd",
		c8 = vim.g.color8 or "#777777",
		c9 = vim.g.color9 or "#ff9999",
		c15 = vim.g.color15 or "#ffffff",
	}

	-- Reconstruct the theme table (Must match your lualine.lua logic)
	local custom_wal = {
		normal = {
			a = { fg = c.c8, bg = c.c1, gui = "bold" },
			b = { fg = c.c9, bg = c.c2 },
			c = { fg = c.c7, bg = c.c4 },
		},
		insert = {
			a = { fg = c.c7, bg = c.c4, gui = "bold" },
			b = { fg = c.c9, bg = c.c2 },
			c = { fg = c.c8, bg = c.c1 },
		},
		visual = {
			a = { fg = c.c1, bg = c.c6, gui = "bold" },
			b = { fg = c.c9, bg = c.c2 },
			c = { fg = c.c7, bg = c.c9 },
		},
		replace = {
			a = { fg = c.c5, bg = c.c9, gui = "bold" },
			b = { fg = c.c9, bg = c.c2 },
			c = { fg = c.c1, bg = c.c5 },
		},
		command = {
			a = { fg = c.c0, bg = c.c15, gui = "bold" },
			b = { fg = c.c9, bg = c.c2 },
			c = { fg = c.c7, bg = c.c1 },
		},
		inactive = {
			a = { fg = c.c9, bg = c.c1 },
			b = { fg = c.c9, bg = c.c1 },
			c = { fg = c.c9, bg = c.c1 },
		},
	}

	-- Force Lualine to reset with the new theme
	require("lualine").setup({ options = { theme = custom_wal } })
end

local function apply_alpha_colors()
	-- CHANGE HERE: Swapped color2 to color4 as requested
	local ascii_art = vim.g.color4 or "#88aa77"
	local buttons = vim.g.color5 or "#d08770"
	local footer = vim.g.color8 or "#555555"

	vim.api.nvim_set_hl(0, "AlphaHeader", { fg = ascii_art })
	vim.api.nvim_set_hl(0, "AlphaButtons", { fg = buttons })
	vim.api.nvim_set_hl(0, "AlphaFooter", { fg = footer })

	vim.cmd("redraw!")
end

-- 1. Watcher
if _G.WalWatcher then
	_G.WalWatcher:stop()
	_G.WalWatcher = nil
end

_G.WalWatcher = vim.loop.new_fs_event()

local function on_change(err, fname, status)
	-- FIX: Add a 100ms delay.
	-- This allows the file system to finish writing the new colors
	-- before we try to read them. This prevents loading "old" or "empty" values.
	vim.defer_fn(function()
		vim.cmd("source " .. wal_file)
		vim.cmd("colorscheme wal")
		apply_alpha_colors()
		reload_lualine() -- Reload Lualine here
	end, 100)
end

_G.WalWatcher:start(wal_file, {}, on_change)

-- 2. Safety Net
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		apply_alpha_colors()
	end,
})
