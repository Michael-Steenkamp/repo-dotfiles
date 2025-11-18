-- Basic Keymaps
-- See ':help vim.keymap.set()'
local keymap = vim.keymap.set
local function opts(desc)
	local options = {
		noremap = true,
		silent = true,
		desc = desc,
	}
	return options
end

-- Toggle List (Listchars Visibility)
keymap("n", "<leader>otl", "<cmd>lua vim.cmd('set list!')<CR>", opts("[O]ptions [T]oggle [L]ist Characters"))

-- Quit
keymap("n", "<leader>gd", "<cmd>w | Alpha<CR><esc>", opts("[G]oto [D]ashboard"))

-- Save File
keymap("i", "<C-s>", "<cmd>w<CR><esc>", opts("Save File"))
keymap("x", "<C-s>", "<cmd>w<CR><esc>", opts("Save File"))
keymap("n", "<C-s>", "<cmd>w<CR><esc>", opts("Save File"))
keymap("s", "<C-s>", "<cmd>w<CR><esc>", opts("Save File"))

-- Better Pasting
keymap("v", "p", '"_dp', opts("Paste Without Yanking"))
keymap("v", "c", '"_c', opts("Change Without Yanking"))
keymap("n", "c", '"_c', opts("Change Without Yanking"))
keymap("n", "d", '"_d', opts("Delete Without Yanking"))
keymap("v", "d", '"_d', opts("Delete Without Yanking"))

-- See ':help telescope.builtin'
local builtin = require("telescope.builtin")
keymap("n", "<leader>sf", builtin.find_files, opts("[S]Search [F]iles"))
keymap("n", "<leader>sg", builtin.live_grep, opts("[S]Search By [G]rep"))
keymap("n", "<leader>sr", builtin.resume, opts("[S]Search [R]esume"))
keymap("n", "<leader>s.", builtin.oldfiles, opts('[S]Search Recent Files ("." for repeat)'))
keymap("n", "<leader>sd", builtin.diagnostics, opts("[S]Search [D]iagnostics"))
keymap("n", "<leader>sw", builtin.grep_string, opts("[S]Search Current [W]ord"))
keymap("n", "<leader>ss", builtin.builtin, opts("[S]Search [S]elect Telescope"))
keymap("n", "<leader>sk", builtin.keymaps, opts("[S]Search [K]eymaps"))
keymap("n", "<leader>sh", builtin.help_tags, opts("[S]Search [H]elp"))
keymap("n", "<leader><leader>", builtin.buffers, opts("[] Find Existing Buffers"))

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
