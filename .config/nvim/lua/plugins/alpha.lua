return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local art = require("utils.ascii")

		local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")
		if vim.fn.filereadable(wal_file) == 1 then
			vim.cmd("source " .. wal_file)
		end

		-- Logic to pick random art
		local keys = {}
		for k, _ in pairs(art) do
			table.insert(keys, k)
		end
		math.randomseed(os.time())
		local random_key = keys[math.random(#keys)]
		local selected_art = art[random_key]
		dashboard.section.header.val = selected_art

		-- Apply the Custom Highlights
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
			dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
			dashboard.button("n", "  New File", ":ene | startinsert <CR>"),
			dashboard.button("c", "  Config", ":cd ~/.config/nvim/ | Telescope find_files<CR>"),
			dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
			dashboard.button("m", "󰈏  Mason", ":Mason<CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		-- ============================================================
		-- DYNAMIC CENTER LAYOUT
		-- ============================================================

		-- 1. Get Terminal Height
		local screen_height = vim.o.lines

		-- 2. Decide where buttons should sit (e.g., 50% down the screen)
		--    Change 0.5 to 0.4 to move higher, or 0.6 to move lower.
		local button_row_target = math.floor(screen_height * 0.5)

		-- 3. Calculate Padding
		local art_height = #selected_art
		local top_padding = 2 -- Minimum space at the very top

		-- The gap needed to reach the target row
		local gap = button_row_target - art_height - top_padding

		-- Safety: Ensure gap is never negative (if art is huge)
		if gap < 2 then
			gap = 2
		end

		dashboard.config.layout = {
			{ type = "padding", val = top_padding },
			dashboard.section.header,
			{ type = "padding", val = gap },
			dashboard.section.buttons,
			dashboard.section.footer,
		}
		alpha.setup(dashboard.config)

		-- INITIAL SETUP
		-- Now that we forced source above, these should be correct immediately
		local ascii_color = vim.g.color2 or "#88aa77"
		local button_color = vim.g.color5 or "#d08770"
		local text_color = vim.g.color8 or "#4c566a"

		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = ascii_color })
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = button_color })
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = text_color })
	end,
}
