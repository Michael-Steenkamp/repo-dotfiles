return {

	{
		"dylanaraps/wal.vim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Just apply the colorscheme (this includes the dark background)
			vim.cmd("colorscheme wal")

			-- Keep this so Lualine still updates correctly
			if package.loaded["lualine"] then
				require("lualine").setup({ options = { theme = "auto" } })
			end
		end,
	},
}
