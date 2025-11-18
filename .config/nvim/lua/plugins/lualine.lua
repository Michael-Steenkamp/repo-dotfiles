return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- Uses mini.icons if mocked
	event = "VeryLazy",
	config = function()
		-- Custom function to show which LSP is running (e.g., "lua_ls", "pyright")
		local function get_lsp_name()
			local msg = "No Active LSP"
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto", -- Automatically matches your Catppuccin theme
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha", "dashboard", "neo-tree" },
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true, -- ONE statusline for all splits (Modern look)
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				-- LEFT SIDE
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = "✚ ", modified = " ", removed = "✖ " },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true, -- displays file status (readonly status, modified status)
						newfile_status = false, -- displays new file status (new file means no write after created)
						path = 1, -- 0: Just filename, 1: Relative path, 2: Absolute path

						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},

				-- RIGHT SIDE
				lualine_x = {
					{
						get_lsp_name, -- Shows the active language server
						icon = " ",
						color = { fg = "#fab387", gui = "bold" }, -- Custom color (optional)
					},
					"encoding",
					"fileformat",
				},
				lualine_y = { "filetype" }, -- Shows the language icon (Python, Lua, etc.)
				lualine_z = { "progress", "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			extensions = {},
		})
	end,
}
