local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = false

-- Sync Clipse and Neovim clipboard
vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
        ['+'] = 'wl-copy',
        ['*'] = 'wl-copy',
    },
    paste = {
        ['+'] = 'wl-paste',
        ['*'] = 'wl-paste',
    },
    cache_enabled = 1,
}
-- See ':help clipboard'
vim.schedule(function()
    opt.clipboard = "unnamedplus"
end)
opt.updatetime = 200 -- Decrease update time

-- Tabs & Indentation
opt.tabstop = 4           -- Tabs are 4 spaces wide
opt.shiftwidth = 4        -- Indents are 4 spaces wide
opt.expandtab = true      -- Use spaces instead of tabs
opt.autoindent = true     -- Copy indent from current line when starting a new line

-- Searching
opt.ignorecase = true     -- Case-insensitive searching
opt.smartcase  = true

-- Signcolumn
opt.signcolumn = "yes"
opt.scrolloff = 999

-- Save Undo
opt.undofile = true
opt.timeoutlen = 1000

-- List
opt.list = false
opt.listchars = {
    trail = "·",
    tab = "⭾ ",
    eol = "⏎",
    nbsp = "␣",
    extends = "»",
    precedes = "«",
    lead = "·",
}
