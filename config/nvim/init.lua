vim.loader.enable() -- experimental bytecode compiler

-- disable netrw (we use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.python3_host_prog = vim.fs.joinpath(vim.uv.os_homedir(), "tools/venvs/main/bin/python3")
vim.g.python_version = 311

vim.g.mapleader = " " -- before everything else

require("my.options")
require("my.autocommands")
require("my.keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Essential (non-lazy)
    { -- colorscheme
        "navarasu/onedark.nvim",
        priority = 1000, -- load before other plugins
        opts = {
            style = "deep", -- dark, darker, cool, deep, warm, warmer
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            vim.cmd.colorscheme("onedark")
        end,
    },
    { -- powerline
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                component_separators = { left = "│", right = "│" }, -- \u2502
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = {},
                lualine_y = { "filetype" },
            },
            inactive_sections = { lualine_c = { { "filename", path = 1 } } },
            tabline = { lualine_a = { "buffers" } },
            extensions = { "lazy", "nvim-tree", "toggleterm", "fzf", "fugitive", "quickfix" },
        },
    },
    { -- start page
        "mhinz/vim-startify",
        config = function()
            vim.g.webdevicons_enable_startify = 1
            vim.g.startify_session_autoload = 1
            vim.g.startify_session_delete_buffers = 1
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
            vim.g.startify_fortune_use_unicode = 1
            vim.g.startify_bookmarks = {
                { v = "~/.dotfiles/config/nvim/init.lua" },
                { z = "~/.dotfiles/zshrc" },
                { a = "~/.dotfiles/aliases" },
            }
        end,
    },
    { "tpope/vim-sleuth" }, -- autodetect shiftwidth/expandtab etc
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "microsoft/python-type-stubs",
            "folke/neodev.nvim",
            "folke/which-key.nvim",
        },
        config = function()
            require("neodev").setup({}) -- has to occur before configuring lsp.
            require("my.lsp")
        end,
    },

    -- General Editing
    { "tpope/vim-surround", event = "VeryLazy" }, -- cs/ds/ys
    { "tpope/vim-commentary", event = "VeryLazy" }, -- gc
    { "tpope/vim-repeat", event = "VeryLazy" }, -- .
    { "tpope/vim-unimpaired", event = "VeryLazy" }, -- []
    { "echasnovski/mini.cursorword", event = "VeryLazy", opts = { delay = 0 } },

    -- Code
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
        opts = {
            ensure_installed = "all",
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    keymaps = {
                        ["i,"] = "@parameter.inner",
                        ["a,"] = "@parameter.outer",
                        ["ic"] = "@comment.inner",
                        ["ac"] = "@comment.outer",
                        ["if"] = "@function.inner",
                        ["af"] = "@function.outer",
                        ["il"] = "@class.inner",
                        ["al"] = "@class.outer",
                        ["ix"] = "@call.inner",
                        ["ax"] = "@call.outer",
                    },
                },
            },
        },
    },
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "goimports" },
                json = { "clang_format" },
                -- everything else uses the LSP formatter.
            },
        },
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "emoji" },
                    { name = "nvim_lua" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Project Navigation
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
        event = "VeryLazy",
        config = function() require("my.fzf") end,
    },
    { -- file tree
        "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            sort_by = "case_sensitive",
            view = { width = 30 },
            filters = { dotfiles = false },
            actions = { open_file = { quit_on_open = true } },
            update_focused_file = { enable = true },
        },
        config = function(_, opts)
            require("nvim-tree").setup(opts)
            vim.keymap.set({ "n", "v" }, "<C-f>", vim.cmd.NvimTreeToggle, { desc = "NvimTree" })
        end,
    },
    { "akinsho/toggleterm.nvim", event = "VeryLazy", opts = { open_mapping = [[<C-\>]] } },

    -- Git
    { "tpope/vim-fugitive", event = "VeryLazy" },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        dependencies = { "folke/which-key.nvim" },
        event = "VeryLazy",
        config = function() require("my.gitsigns") end,
    },
})
