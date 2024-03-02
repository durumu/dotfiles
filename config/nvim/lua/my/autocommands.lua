-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Add a color column immediately after the max line length",
    pattern = "*",
    callback = function()
        local max_line_length = {
            lua = 100, -- stylua
            python = 88, -- black/ruff
            c = 80,
            cpp = 80, -- clangd
            rust = 100, -- rustfmt
        }
        local line_length = max_line_length[vim.bo.filetype]
        if line_length then
            vim.wo.colorcolumn = tostring(line_length + 1)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Override indentation defaults for tab-based languages",
    pattern = { "go", "make" },
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 0
        vim.bo.softtabstop = 0
        vim.bo.tabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Allow :make to run cargo commands for rust projects, e.g. :make build",
    pattern = { "rust" },
    callback = function()
        vim.cmd.compiler("cargo")
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Delete trailing whitespace on save",
    pattern = "*",
    callback = function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
    end,
})

vim.api.nvim_set_hl(0, "HighlightTrailingWhitespace", { bg = "#e06c75", fg = "none" })
local match_id = 44357

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
    desc = "Highlight trailing whitespace",
    pattern = "*",
    callback = function()
        local buf = vim.api.nvim_win_get_buf(0)
        if vim.bo[buf].readonly then
            return
        end
        pcall(vim.fn.matchdelete, match_id)
        vim.fn.matchadd("HighlightTrailingWhitespace", [[\s\+$]], 10, match_id)
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
    desc = "Un-highlight trailing whitespace",
    pattern = "*",
    callback = function()
        pcall(vim.fn.matchdelete, match_id)
    end,
})
