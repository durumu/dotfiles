-- disable netrw (we use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.python3_host_prog = "/mys/presley/tools/venvs/main/bin/python3"
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
    { --colorscheme
        "folke/tokyonight.nvim",
        priority = 1000, -- load before other plugins
        config = function()
            require("tokyonight").setup({
                style = "moon", -- bg=dark
                light_style = "day", -- bg=light
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    keywords = { italic = false },
                },
                sidebars = { "qf", "help", "terminal" }, -- darker background on sidebars
                lualine_bold = true, -- bold tab headers in the lualine theme
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    { -- powerline
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            theme = "tokyonight",
            options = {
                component_separators = { left = "│", right = "│" }, -- \u2502
                section_separators = { left = "", right = "" },
            },
            sections = { lualine_c = { { "filename", path = 1 } } },
            inactive_sections = { lualine_c = { { "filename", path = 1 } } },
            tabline = { lualine_a = { "buffers" } },
            extensions = { "lazy" },
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
                { z = "~/.zshrc" },
                { a = "~/.aliases" },
                { e = "~/.zshenv" },
            }
        end,
    },
    { "tpope/vim-sleuth" }, -- autodetect shiftwidth/expandtab etc

    -- General Editing
    { "tpope/vim-surround", event = "VeryLazy" }, -- cs/ds/ys
    { "tpope/vim-commentary", event = "VeryLazy" }, -- gc
    { "tpope/vim-repeat", event = "VeryLazy" }, -- .
    {
        "echasnovski/mini.bracketed",
        event = "VeryLazy",
        opts = { comment = { suffix = "" } }, -- [c reserved for fugitive
    },
    { "echasnovski/mini.cursorword", event = "VeryLazy", opts = { delay = 0 } },
    { -- highlight and delete trailing whitespace
        "echasnovski/mini.trailspace",
        config = function()
            local trailspace = require("mini.trailspace")
            trailspace.setup()

            vim.api.nvim_create_autocmd(
                "BufWritePre",
                { desc = "Delete trailing whitespace on save", callback = trailspace.trim }
            )
        end,
    },
    { "folke/which-key.nvim", event = "VeryLazy", opts = {} }, -- show pending keybinds.

    -- Code
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
        config = function()
            require("my.treesitter")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "microsoft/python-type-stubs",
            "folke/neodev.nvim",
            "folke/which-key.nvim",
        },
        config = function()
            require("neodev").setup({})
            require("my.lsp")
        end,
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
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({})

            vim.keymap.set({ "n", "v" }, "<leader>xx", vim.cmd.TroubleToggle, { desc = "Trouble" })
            vim.keymap.set({ "n", "v" }, "<leader>xq", function()
                vim.cmd.TroubleToggle("quickfix")
            end, { desc = "Trouble (quickfix)" })
        end,
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
    { "github/copilot.vim", event = "VeryLazy" },

    -- Project Navigation
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
        event = "VeryLazy",
        config = function()
            require("my.fzf")
        end,
    },
    { -- file tree
        "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = { width = 30 },
                filters = { dotfiles = false },
                actions = { open_file = { quit_on_open = true } },
                update_focused_file = { enable = true },
            })
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
        config = function()
            require("my.gitsigns")
        end,
    },
})
