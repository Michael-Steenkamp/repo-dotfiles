-- Auto-reload Hyprland/Waybar logic
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/hypr/*.conf",
	callback = function()
		vim.fn.jobstart("hyprctl reload", { detach = true })
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*/waybar/*",
	callback = function()
		vim.fn.jobstart("pkill waybar; waybar & disown", { detach = true })
	end,
})

-- -----------------------------------------------------------
-- PYWAL THEME INTEGRATION
-- -----------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- 1. Force Transparent Background (for the Acrylic look)
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })

		-- 2. Grab Pywal Colors
		-- We try to fetch them from the loaded module, or fallback to terminal vars
		local colors = {
			bg = "NONE",
			fg = "#ffffff",
			accent = "#89b4fa", -- Fallback blue
			dark = "#11111b", -- Fallback black
		}

		-- Try to get colors from pywal16 module
		local status, pywal_core = pcall(require, "pywal16.core")
		if status and pywal_core.get_colors then
			local c = pywal_core.get_colors()
			colors.bg = c.color0
			colors.fg = c.foreground
			colors.accent = c.color4 -- Standard Pywal accent
			colors.dark = c.color0
		end

		-- 3. Apply Colors to Autocomplete Menu (Pmenu)
		-- Pmenu: The unselected items (use Pywal background)
		vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.dark, fg = colors.fg })

		-- PmenuSel: The SELECTED item (Use Pywal Accent Color)
		-- This makes the selection bar match your system theme!
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.accent, fg = colors.dark, bold = true })

		-- PmenuBorder: The rounded border
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.accent, bg = "NONE" })

		-- Documentation window
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.dark })
      
-- Reload Wal colors when Neovim receives SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		vim.cmd("colorscheme wal")
	end,
})
