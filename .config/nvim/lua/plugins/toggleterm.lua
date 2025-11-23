return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,

				-- 1. Clean up visuals for Pywal/Acrylic
				shade_filetypes = {},
				shade_terminals = false, -- Set to false to let your Pywal transparency shine through

				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,

				-- 2. Match Pywal Theme & rounded borders
				float_opts = {
					border = "rounded", -- Matches your Autocomplete menu
					winblend = 0,
					highlights = {
						-- "FloatBorder" links to the Pywal Accent Color we defined in autocmd.lua
						border = "FloatBorder",
						-- "Normal" links to your transparent background
						background = "Normal",
					},
				},
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},
}
