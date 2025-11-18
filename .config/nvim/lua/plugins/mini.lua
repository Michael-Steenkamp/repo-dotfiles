return {
	"echasnovski/mini.nvim",
	version = false, -- Use main branch (recommended for mini.nvim)
	config = function()
		----------------------------------------------------------------------
		-- INSTALLED MODULES:
		-- 1. mini.icons       (Replaces nvim-web-devicons)
		-- 2. mini.ai          (Better text objects: a), i), a?)
		-- 3. mini.surround    (Add/Delete/Replace surroundings: sa, sd, sr)
		-- 4. mini.pairs       (Auto-close brackets and quotes)
		-- 5. mini.comment     (Fast commenting: gc)
		-- 6. mini.indentscope (Animated indent guides)
		-- 7. mini.move        (Move lines with Alt+hjkl)
		-- 8. mini.bufremove   (Close buffers without closing windows)
		-- 9. mini.trailspace  (Highlight trailing whitespace)
		-- 10. mini.cursorword (Highlight the word under the cursor)
		----------------------------------------------------------------------

		-- 1. ICONS (Replaces nvim-web-devicons)
		local icons = require("mini.icons")
		icons.setup({})
		icons.mock_nvim_web_devicons()

		-- 2. BETTER TEXT OBJECTS (mini.ai)
		require("mini.ai").setup({
			n_lines = 500,
			search_method = "cover_or_next",
		})

		-- 3. SURROUND ACTIONS (mini.surround)
		require("mini.surround").setup({
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
			},
		})

		-- 4. AUTO PAIRS (mini.pairs)
		require("mini.pairs").setup({
			modes = { insert = true, command = false, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		})

		-- 5. COMMENTING (mini.comment)
		require("mini.comment").setup({
			options = { pad_comment_parts = true },
			mappings = {
				comment = "gc",
				comment_line = "gcc",
				comment_visual = "gc",
				textobject = "gc",
			},
		})

		-- 6. INDENT SCOPE (mini.indentscope)
		require("mini.indentscope").setup({
			symbol = "│",
			options = { try_as_border = true },
			draw = {
				delay = 100,
				animation = require("mini.indentscope").gen_animation.none(),
			},
		})

		-- Disable indentscope for certain filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		-- 7. MOVE LINES (mini.move)
		require("mini.move").setup({
			mappings = {
				left = "<M-h>",
				right = "<M-l>",
				down = "<M-j>",
				up = "<M-k>",
				line_left = "<M-h>",
				line_right = "<M-l>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},
			options = { reindent_linewise = true },
		})

		-- 8. BUFFER REMOVE (mini.bufremove)
		require("mini.bufremove").setup({})
		vim.keymap.set("n", "<leader>bd", function()
			require("mini.bufremove").delete(0, false)
		end, { desc = "Delete Buffer" })

		-- 9. TRAILING WHITESPACE (mini.trailspace)
		require("mini.trailspace").setup({ only_in_normal_buffers = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				require("mini.trailspace").trim()
			end,
		})

		-- 10. CURSOR WORD (mini.cursorword)
		require("mini.cursorword").setup({ delay = 100 })
	end,
}
