-- Basic Keymaps
-- See ':help keymap()'
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
keymap({ "n", "v" }, "<leader>w", "<cmd>noautocmd w<CR>", opts("Save without formatting"))

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
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- =============================================================================
-- LSP / INTELLISENSE KEYMAPS
-- These generally only work when an LSP (like pyright/clangd) is active
-- =============================================================================

-- 1. Go to Definition
-- Jumps to the file and line where the variable/function was created
keymap("n", "gd", vim.lsp.buf.definition, opts("[G]oto [D]efinition"))

-- 2. Go to Declaration
-- Slightly different from definition (mostly for C/C++ header files)
keymap("n", "gD", vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))

-- 3. Go to Implementation
-- Useful for languages like Go/Rust/Java to see interface implementations
keymap("n", "gi", vim.lsp.buf.implementation, opts("[G]oto [I]mplementation"))

-- 4. Hover Documentation
-- Shows a popup with documentation for the symbol under the cursor
keymap("n", "K", vim.lsp.buf.hover, opts("Hover Documentation"))

-- 5. Signature Help
-- Shows function arguments popup while typing (useful when creating instances)
keymap("i", "<C-k>", vim.lsp.buf.signature_help, opts("Signature Help"))

-- 6. Rename
-- Renames the variable under cursor across the entire project safely
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("[R]e[n]ame"))

-- 7. Code Action
-- Opens the Quick Fix menu (Import missing library, Fix spelling, etc.)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts("[C]ode [A]ction"))

-- 8. Type Definition
-- Jumps to the definition of the *type* of the variable under cursor
keymap("n", "<leader>D", vim.lsp.buf.type_definition, opts("Type [D]efinition"))

-- =============================================================================
-- DIAGNOSTICS (Error/Warning Navigation)
-- =============================================================================

-- Show the error message for the current line in a floating window
keymap("n", "gl", vim.diagnostic.open_float, opts("Show line diagnostics"))

-- Jump to previous/next error
keymap("n", "[d", vim.diagnostic.goto_prev, opts("Previous Diagnostic"))
keymap("n", "]d", vim.diagnostic.goto_next, opts("Next Diagnostic"))
