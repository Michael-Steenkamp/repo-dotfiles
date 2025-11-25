-- ~/.config/nvim/lua/plugins/wal.lua
return {
	{
		"dylanaraps/wal.vim",
		lazy = false, -- Load immediately so the theme applies on startup
		priority = 1000,
		config = function()
			vim.cmd("colorscheme wal")
		end,
	},
}
