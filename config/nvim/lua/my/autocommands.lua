-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    pattern = "*",
    callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
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
    callback = function() vim.cmd.compiler("cargo") end,
})
