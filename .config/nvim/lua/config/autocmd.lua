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
      
-- Reload Wal colors when Neovim receives SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		vim.cmd("colorscheme wal")
	end,
})
