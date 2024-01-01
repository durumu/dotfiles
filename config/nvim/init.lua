-- disable netrw
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
        config = function()
            require("tokyonight").setup({
                style = "moon", -- bg=dark
                light_style = "day", -- bg=light
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = false },
                    functions = {},
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
                sidebars = { "qf", "help", "terminal" }, -- darker background on sidebars
                lualine_bold = true, -- section headers in the lualine theme will be bold
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    { -- powerline
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = "│", right = "│" }, -- \u2502
                    section_separators = { left = "", right = "" },
                },
                sections = { lualine_c = { { "filename", path = 1 } } },
                inactive_sections = { lualine_c = { { "filename", path = 1 } } },
                tabline = { lualine_a = { "buffers" } },
                extensions = { "lazy" },
            })
        end,
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
    { -- make . work with other tpope plugins
        "tpope/vim-repeat",
    },
    { -- cs/ds/ys
        "tpope/vim-surround",
    },
    { -- gc for line comment, gb for block comment
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require("Comment").setup()
        end,
    },
    { -- []
        "tpope/vim-unimpaired",
    },
    { -- <C-a> and <C-x> for dates
        "tpope/vim-speeddating",
    },
    { -- text objects - ie/ae
        "kana/vim-textobj-entire",
        dependencies = { "kana/vim-textobj-user" },
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
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

            local format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local on_attach = function(_, bufnr)
                -- Enable completion
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "gn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

                vim.api.nvim_create_autocmd("BufWritePre", {
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
                    -- Add a ruff autofix
                    -- vim.api.nvim_create_user_command("T", ..., {})
                    vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })
                    on_attach(client, bufnr)

                    -- Automatically organize imports on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.code_action({
                                filter = function(code_action)
                                    -- kind of a hack, but idk how to do this better
                                    return code_action.title == "Ruff: Organize Imports"
                                end,
                                apply = true,
                            })
                        end,
                    })
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
                        -- Neovim uses LuaJIT
                        format = { enable = false },
                        runtime = { version = "LuaJIT" },
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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
        },
        config = function()
            -- vim.keymap.set({ "i" }, "<Tab>", function()
            --     if vim.fn.pumvisible() == 1 then
            --         return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
            --     else
            --         return vim.api.nvim_replace_termcodes("<TAB>", true, true, true)
            --     end
            -- end)
            --
            -- vim.keymap.set({ "i" }, "<S-Tab>", function()
            --     if vim.fn.pumvisible() == 1 then
            --         return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)
            --     else
            --         return vim.api.nvim_replace_termcodes("<C-h>", true, true, true)
            --     end
            -- end)
            --
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Project Navigation
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<C-p>", mode = { "n", "v" } }, { "<leader>rg", mode = { "n", "v" } } },
        cmd = "Rg",
        config = function()
            vim.keymap.set({ "n", "v" }, "<C-p>", function()
                require("fzf-lua").git_files()
            end, { silent = true })

            vim.api.nvim_create_user_command("Rg", function(arg)
                require("fzf-lua").grep({ search = arg.args })
            end, { nargs = "*" })

            vim.keymap.set({ "n" }, "<leader>rg", function()
                require("fzf-lua").grep()
            end, { silent = true })
            vim.keymap.set({ "v" }, "<leader>rg", function()
                require("fzf-lua").grep({ search = require("fzf-lua").utils.get_visual_selection() })
            end, { silent = true })

            -- also, need to install: rg, fd, bat
            require("fzf-lua").setup({})
        end,
    },
    { -- :G
        "tpope/vim-fugitive",
    },
    { -- :GitMessenger (<space>gm)
        "rhysd/git-messenger.vim",
    },
    { -- file tree
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree", mode = { "n", "v" } },
        },
        config = function()
            require("nvim-tree").setup({
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
            })
        end,
    },

    -- Autoformat
    { -- rust
        "rust-lang/rust.vim",
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    { -- lua
        "ckipp01/stylua-nvim",
        ft = { "lua" },
        config = function()
            require("stylua-nvim").setup({
                config_file = "/Users/presley/.dotfiles/config/stylua.toml",
            })
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.lua" },
                callback = function()
                    require("stylua-nvim").format_file()
                end,
            })
        end,
    },

    -- Productivity
    { -- terminal (<C-\>)
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({ open_mapping = [[<C-\>]] })
        end,
    },
    { -- :Chat
        "dpayne/CodeGPT.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        cmd = "Chat",
        config = function()
            require("codegpt.config")
        end,
    },
})

-- Editor Config
vim.cmd([[highlight Comment cterm=italic gui=italic]])
vim.cmd([[filetype plugin on]])

vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. "g2" .. "h2"
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.mouse = "r"
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 300

vim.wo.number = true

-- dark grey column right past max line length
vim.cmd([[highlight ColorColumn ctermbg=darkgrey]])

vim.api.nvim_exec(
    [[
  augroup SetColorColumn
      autocmd!
      autocmd FileType lua setlocal colorcolumn=101
      autocmd FileType python setlocal colorcolumn=89
      autocmd FileType c,cpp,rust setlocal colorcolumn=81
  augroup END
]],
    false
)

-- Mappings
-- remaps
vim.keymap.set({ "n", "v" }, "Y", "y$", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "Q", "q", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "q", "@q", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+y$', { noremap = true, silent = true })

-- navigation
vim.keymap.set({ "n", "v" }, "<left>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<down>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<up>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<right>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-left>", "<C-w>H", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-down>", "<C-w>J", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-up>", "<C-w>K", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-right>", "<C-w>L", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<enter>", "<C-]>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<tab>", function()
    vim.cmd([[bnext]])
end)
vim.keymap.set({ "n", "v" }, "<S-tab>", function()
    vim.cmd([[bprevious]])
end)

vim.keymap.set({ "n", "v" }, "<leader><leader>", function()
    vim.cmd([[noh]])
end)
vim.keymap.set({ "n", "v" }, "<leader>bd", function()
    vim.cmd([[bd]])
end)

-- Plugin Mappings

-- Command
vim.api.nvim_create_user_command("Q", "qall", {})
vim.api.nvim_create_user_command("W", "wall", {})
vim.api.nvim_create_user_command("X", "xall", {})

-- delete trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
        local current_pos = vim.api.nvim_win_get_cursor(0) -- Save current cursor position
        vim.api.nvim_command(":%s/\\s\\+$//e")
        vim.api.nvim_win_set_cursor(0, current_pos) -- Restore cursor position
    end,
})
