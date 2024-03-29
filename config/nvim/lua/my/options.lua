-- General
vim.o.undofile = true -- Enable persistent undo (see also `:h undodir`)

-- Appearance
vim.o.cursorline = true -- Highlight current line
vim.o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.number = true -- Show line number on current line
vim.o.relativenumber = true -- Relative line numbers
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.signcolumn = "yes:1" -- Always show sign column (otherwise it will shift text)
vim.o.fillchars = "eob: " -- Don't show `~` outside of buffer

-- Editing
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.o.smartcase = true -- Don't ignore case when searching if pattern has upper case

-- Tabs (default -- vim-sleuth will usually override)
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.o.softtabstop = 4 -- Number of spaces that <Tab> counts for while performing editing operations
vim.o.tabstop = 4 -- When forced to use tab, make it this wide
