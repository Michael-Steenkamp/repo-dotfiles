return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	config = function()
        local art = require('utils.ascii')
		require("dashboard").setup({
            -- These are top-level options
			theme = "doom",
			disable_move = false,
			shortcut_type = "letter",
			shuffle_letter = false,
			change_to_vcs_root = false,

			preview = {
				command = "",
				file_path = "",
				file_height = 0,
				file_width = 0,
			},

			hide = {
				statusline = true,
				tabline = true,
				winbar = true,
			},

			-- This 'config' table is passed to the theme ('hyper' in this case)
			config = {
				-- 'letter_list' must go IN HERE
				letter_list = "abcdefghilmnopqrstuvwxyz", -- Default list (a-z, no j, k)

				-- All theme-specific options also go here
				week_header = {
					enable = false,
				},
				shortcut = {}, -- Add your shortcuts here
				packages = {
					enable = true,
				},
				project = {
					enable = true,
					limit = 8,
					icon = " ",
					label = "",
					action = "Telescope find_files cwd=",
				},
				mru = {
					enable = true,
					limit = 10,
					icon = " ",
					label = "",
					cwd_only = false,
				},
				header = art.saturn,
				footer = {},
			},
		})
	end,
}
