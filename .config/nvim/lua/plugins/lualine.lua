return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		-- 1. FORCE LOAD the Wallust colors immediately
		--    This ensures 'g:color0' etc. are defined before we try to use them.
		local wal_colors = vim.fn.expand("~/.cache/wal/colors-wal.vim")
		if vim.fn.filereadable(wal_colors) == 1 then
			vim.cmd("source " .. wal_colors)
		end

		-- 2. Load variables (c0 - c15)
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
			c10 = vim.g.color10 or "#99ff99",
			c11 = vim.g.color11 or "#ffff99",
			c12 = vim.g.color12 or "#9999ff",
			c13 = vim.g.color13 or "#ff99ff",
			c14 = vim.g.color14 or "#99ffff",
			c15 = vim.g.color15 or "#ffffff",
		}

		-- 3. Define the Theme
		local custom_wal = {
			normal = {
				a = { fg = c.c4, bg = c.c9, gui = "bold" },
				b = { fg = c.c8, bg = c.c0 },
				c = { fg = c.c7, bg = c.c2 },
			},
			insert = {
				a = { fg = c.c7, bg = c.c2, gui = "bold" },
				c = { fg = c.c7, bg = c.c9 },
			},
			visual = {
				a = { fg = c.c1, bg = c.c6, gui = "bold" },
				c = { fg = c.c7, bg = c.c0 },
			},
			replace = {
				a = { fg = c.c5, bg = c.c9, gui = "bold" },
				c = { fg = c.c1, bg = c.c5 },
			},
			command = {
				a = { fg = c.c0, bg = c.c15, gui = "bold" },
				c = { fg = c.c7, bg = c.c2 },
			},
			inactive = {
				a = { fg = c.c9, bg = c.c1 },
				b = { fg = c.c9, bg = c.c1 },
				c = { fg = c.c9, bg = c.c1 },
			},
		}

		require("lualine").setup({
			options = {
				theme = custom_wal,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "filetype", "encoding" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
