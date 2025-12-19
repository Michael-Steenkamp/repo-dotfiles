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

-- ============================================================
--  Wallust Live Theme Reloader
-- ============================================================
local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")

-- Stop any existing watcher to prevent duplicates
if _G.WalWatcher then
	_G.WalWatcher:stop()
	_G.WalWatcher = nil
end

_G.WalWatcher = vim.loop.new_fs_event()

local function on_change(err, fname, status)
	vim.schedule(function()
		-- 1. Source the new generated colors (Now with g: variables!)
		vim.cmd("source " .. wal_file)

		-- 2. Re-apply the colorscheme
		vim.cmd("colorscheme wal")

		-- 3. FORCE LUALINE UPDATE
		-- We must manually reconstruct the theme table and pass it to setup()
		-- because the original config in lualine.lua only ran once at startup.
		if package.loaded["lualine"] then
			local colors = {
				bg = vim.g.color2 or "#202020",
				fg = vim.g.color7 or "#dddddd",
				accent = vim.g.color4 or "#88aa77",
				surface = vim.g.color1 or "#303030",
				alert = vim.g.color6 or "#cc5555",
				disabled = vim.g.color8 or "#777777",
			}

			local custom_wal = {
				normal = {
					a = { fg = colors.bg, bg = colors.accent, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface },
					c = { fg = colors.fg, bg = colors.bg },
				},
				insert = { a = { fg = colors.bg, bg = colors.alert, gui = "bold" } },
				visual = { a = { fg = colors.bg, bg = colors.fg, gui = "bold" } },
				replace = { a = { fg = colors.bg, bg = colors.alert, gui = "bold" } },
				command = { a = { fg = colors.bg, bg = colors.accent, gui = "bold" } },
				inactive = {
					a = { fg = colors.disabled, bg = colors.bg },
					b = { fg = colors.disabled, bg = colors.bg },
					c = { fg = colors.disabled, bg = colors.bg },
				},
			}

			-- Re-run setup with the new theme
			require("lualine").setup({
				options = {
					theme = custom_wal,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
			})
		end
	end)
end

_G.WalWatcher:start(wal_file, {}, on_change)
