-- disable netrw (we use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.python3_host_prog = "/Users/presley/tools/venvs/main/bin/python3"

vim.g.python_version = 311

vim.g.mapleader = " "

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
    -- Essential
    { --colorscheme
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000, -- load before other plugins
        opts = {
            style = "moon", -- bg=dark
            light_style = "day", -- bg=light
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                keywords = { italic = false },

                -- Background styles. Can be "dark", "transparent" or "normal"
                sidebars = "dark", -- style for sidebars, see below
                floats = "dark", -- style for floating windows
            },
            sidebars = { "qf", "help", "terminal" }, -- darker background on sidebars
            lualine_bold = true, -- section headers in the lualine theme will be bold
        },
    },
    { -- powerline
        "nvim-lualine/lualine.nvim",
        lazy = false,
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
        lazy = false,
        config = function()
            vim.g.webdevicons_enable_startify = 1
            vim.g.startify_session_autoload = 1
            vim.g.startify_session_delete_buffers = 1
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
            vim.g.startify_fortune_use_unicode = 1
            vim.g.startify_bookmarks = {
                { v = "~/.config/nvim/init.lua" },
                { z = "~/.zshrc" },
                { a = "~/.aliases" },
            }
        end,
    },

    -- General Editing
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.basics").setup()
            require("mini.bracketed").setup()
            require("mini.comment").setup()
            require("mini.cursorword").setup()
            require("mini.trailspace").setup()

            vim.api.nvim_create_autocmd("BufWritePre", {
                desc = "Delete trailing whitespace on save",
                callback = require("mini.trailspace").trim,
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                modules = {},
                sync_install = false,
                ensure_installed = "all",
                auto_install = true,
                ignore_install = {},
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            ["i,"] = "@parameter.inner",
                            ["a,"] = "@parameter.outer",
                            ["ia"] = "@attribute.inner",
                            ["aa"] = "@attribute.outer",
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
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local on_attach = function(_, bufnr)
                -- Enable completion
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local bufopts = { silent = true, buffer = bufnr }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "gn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

                vim.api.nvim_create_autocmd("BufWritePre", {
                    desc = "Format on save",
                    group = format_augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            local lsp = require("lspconfig")

            lsp.pyright.setup({
                cmd = { "/Users/presley/tools/venvs/main/bin/pyright-langserver", "--stdio" },
                on_attach = on_attach,
                settings = {
                    python = {
                        pythonPath = vim.g.python3_host_prog,
                        analysis = {
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
            })

            lsp.ruff_lsp.setup({
                cmd = { "/Users/presley/tools/venvs/main/bin/ruff-lsp" },
                on_attach = function(client, bufnr)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false

                    vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })

                    on_attach(client, bufnr)

                    local perform_code_action_titled = function(title)
                        vim.lsp.buf.code_action({
                            filter = function(code_action)
                                return code_action.title == title
                            end,
                            apply = true,
                        })
                    end

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        desc = "Automatically organize imports on save",
                        group = format_augroup,
                        buffer = bufnr,
                        callback = function()
                            perform_code_action_titled("Ruff: Organize Imports")
                        end,
                    })

                    vim.api.nvim_create_user_command("T", function()
                        perform_code_action_titled("Ruff: Fix All")
                    end, { desc = "Fix all" })
                end,
            })

            lsp.rust_analyzer.setup({
                settings = { ["rust-analyzer"] = { trace = { server = "verbose" } } },
                on_attach = on_attach,
            })

            lsp.clangd.setup({
                settings = { fallbackFlags = { "-std=c++2a" } },
                on_attach = on_attach,
            })

            -- This setup is intended for neovim plugins
            lsp.lua_ls.setup({
                settings = {
                    Lua = {
                        format = { enable = false }, -- I use stylua for formatting
                        runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        diagnostics = { globals = { "vim" } },
                    },
                },
                on_attach = on_attach,
            })
        end,
    },

    -- Autocomplete
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "zbirenbaum/copilot-cmp",
        },
        config = function()
            require("copilot_cmp").setup()

            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                    { name = "copilot" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Project Navigation
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = true,
        keys = {
            {
                "<C-p>",
                mode = { "n", "v" },
                function()
                    require("fzf-lua").git_files()
                end,
            },
            { "<leader>rg", mode = { "n", "v" } },
        },
        cmd = "Rg",
        config = function()
            local opts = { silent = true }
            local fzf = require("fzf-lua")

            vim.api.nvim_create_user_command("Rg", function(arg)
                fzf.grep({ search = arg.args })
            end, { nargs = "*" })

            vim.keymap.set({ "n" }, "<leader>rg", fzf.grep, opts)

            -- like s.strip() in python
            local strip = function(s)
                return (s:gsub("^%s*(.-)%s*$", "%1"))
            end

            vim.keymap.set({ "v" }, "<leader>rg", function()
                fzf.grep({
                    search = strip(fzf.utils.get_visual_selection()),
                })
            end, opts)

            -- also, need to install: rg, fd, bat
            fzf.setup({})
        end,
    },
    { -- :G
        "tpope/vim-fugitive",
    },
    { -- git blame window
        "rhysd/git-messenger.vim",
        keys = { "<leader>gm" },
    },
    { -- file tree
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<C-f>", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree", mode = { "n", "v" } },
        },
        opts = {
            sort_by = "case_sensitive",
            view = {
                width = 30,
            },
            filters = {
                dotfiles = false,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            update_focused_file = {
                enable = true,
            },
        },
    },

    { -- autoformat lua
        "ckipp01/stylua-nvim",
        ft = { "lua" },
        config = function()
            local stylua = require("stylua-nvim")
            stylua.setup({
                config_file = "/Users/presley/.dotfiles/config/stylua.toml",
            })
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                desc = "Format file on save",
                pattern = "*.lua",
                callback = stylua.format_file,
            })
        end,
    },

    { -- terminal (<C-\>)
        "akinsho/toggleterm.nvim",
        keys = { [[<C-\>]] },
        opts = { open_mapping = [[<C-\>]] },
    },
})

-- Editor Config
vim.cmd.colorscheme("tokyonight")

vim.api.nvim_create_autocmd("FileType", {
    desc = "Add a color column right past the max line length",
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

-- Mappings
local opts = { silent = true }

-- remaps
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+y$', opts)

-- navigation
vim.keymap.set({ "n", "v" }, "<left>", "<C-w>h", opts)
vim.keymap.set({ "n", "v" }, "<down>", "<C-w>j", opts)
vim.keymap.set({ "n", "v" }, "<up>", "<C-w>k", opts)
vim.keymap.set({ "n", "v" }, "<right>", "<C-w>l", opts)
vim.keymap.set({ "n", "v" }, "<S-left>", "<C-w>H", opts)
vim.keymap.set({ "n", "v" }, "<S-down>", "<C-w>J", opts)
vim.keymap.set({ "n", "v" }, "<S-up>", "<C-w>K", opts)
vim.keymap.set({ "n", "v" }, "<S-right>", "<C-w>L", opts)

vim.keymap.set({ "n", "v" }, "<tab>", vim.cmd.bnext, opts)
vim.keymap.set({ "n", "v" }, "<S-tab>", vim.cmd.bprevious, opts)

vim.keymap.set({ "n", "v" }, "<enter>", "<C-]>", opts)

vim.keymap.set({ "n", "v" }, "<leader><leader>", vim.cmd.noh, opts)
