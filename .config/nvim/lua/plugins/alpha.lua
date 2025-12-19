return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Make sure this file exists at lua/utils/ascii.lua
		local art = require("utils.ascii")

		-- LOGIC: Get a random key from the art table
		local keys = {}
		for k, _ in pairs(art) do
			table.insert(keys, k)
		end

		-- Use os.time() for the seed so it changes every time you open nvim
		math.randomseed(os.time())
		local random_key = keys[math.random(#keys)]

		-- Set the header
		-- CHANGE: "Function" -> "String" (Usually the main accent color in Wal)
		dashboard.section.header.opts.hl = "String"
		dashboard.section.header.val = art[random_key]

		-- Set the buttons
		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
			dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
			dashboard.button("n", "  New File", ":ene | startinsert <CR>"),
			dashboard.button("c", "  Config", ":cd ~/.config/nvim/ | Telescope find_files<CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.config)
	end,
}
