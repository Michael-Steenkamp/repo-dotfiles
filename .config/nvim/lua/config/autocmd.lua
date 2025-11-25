-- Reload Wal colors when Neovim receives SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		vim.cmd("colorscheme wal")
	end,
})
