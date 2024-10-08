-- navigation
vim.keymap.set(
    { "n", "v" },
    "j",
    [[v:count == 0 ? 'gj' : 'j']],
    { expr = true, desc = "Move down by display line" }
)
vim.keymap.set(
    { "n", "v" },
    "k",
    [[v:count == 0 ? 'gk' : 'k']],
    { expr = true, desc = "Move up by display line" }
)

for _, delimiter in ipairs({ "'", "`", '"' }) do
    vim.keymap.set(
        { "o", "v" },
        "a" .. delimiter,
        "2i" .. delimiter,
        { desc = "Select inside " .. delimiter .. ", excluding whitespace" }
    )
end

-- windows
vim.keymap.set("n", "<left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<down>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<up>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<right>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<S-left>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<S-down>", "<C-w>J", { desc = "Move window to the bottom" })
vim.keymap.set("n", "<S-up>", "<C-w>K", { desc = "Move window to the top" })
vim.keymap.set("n", "<S-right>", "<C-w>L", { desc = "Move window to the right" })

vim.keymap.set("n", "<S-tab>", vim.cmd.bprevious, { desc = "Previous buffer" })
vim.keymap.set("n", "<tab>", vim.cmd.bnext, { desc = "Next buffer" })

-- yanking
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+y$', { desc = "Yank to end of line" })

-- search
-- drop highlight on these, since mini.cursorword already highlights current word
vim.keymap.set(
    "n",
    "*",
    "*:noh<CR>",
    { desc = "Search backwards for word under cursor", silent = true }
)
vim.keymap.set(
    "n",
    "#",
    "#:noh<CR>",
    { desc = "Search forwards for word under cursor", silent = true }
)

vim.keymap.set("n", "<leader><leader>", vim.cmd.noh, { desc = "Clear search highlight" })

-- diagnostic
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show full text in hover" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- quickfix ([Q, [q and ]q added by vim-unimpaired)
vim.keymap.set("n", "<leader>qq", vim.cmd.cwindow, { desc = "Toggle quickfix window" })
vim.keymap.set("n", "<leader>qo", vim.cmd.copen, { desc = "Open quickfix window" })
vim.keymap.set("n", "<leader>qc", vim.cmd.cclose, { desc = "Close quickfix window" })
vim.keymap.set("n", "<leader>qn", vim.cmd.cnfile, { desc = "Quickfix next file" })

vim.api.nvim_create_user_command("Love", function()
    local current_dir = vim.fn.expand("%:p:h")
    local git_dir = require("lspconfig").util.find_git_ancestor(current_dir)
    vim.cmd("!love " .. git_dir)
end, { desc = "Run love command" })
