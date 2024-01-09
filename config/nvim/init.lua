-- disable netrw (we use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.python3_host_prog = "/Users/presley/tools/venvs/main/bin/python3"
vim.g.python_version = 311

vim.g.mapleader = " " -- before everything else

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
        opts = {
            style = "moon", -- bg=dark
            light_style = "day", -- bg=light
            styles = {
                -- Style to be applied to different syntax groups
                -- Value is any valid attr-list value for `:help nvim_set_hl`
                keywords = { italic = false },
            },
            sidebars = { "qf", "help", "terminal" }, -- darker background on sidebars
            lualine_bold = true, -- bold tab headers in the lualine theme
        },
        init = function()
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
            -- [[ Configure LSP ]]
            -- from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(_, bufnr)
                -- Function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = "LSP: " .. desc
                    end

                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                end

                nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
                nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

                -- See `:help K` for why this keymap
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")
                nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
            end

            -- document existing key chains
            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
                ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
                ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
            })
            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            require("which-key").register({
                ["<leader>"] = { name = "VISUAL <leader>" },
                ["<leader>h"] = { "Git [H]unk" },
            }, { mode = "v" })

            local sign_gutter_character = {
                DiagnosticSignError = "",
                DiagnosticSignWarn = "",
                DiagnosticSignHint = "",
                DiagnosticSignInfo = "",
            }
            for sign, char in pairs(sign_gutter_character) do
                vim.fn.sign_define(sign, { text = char, texthl = sign, linehl = "", numhl = "" })
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

            local organize_augroup = "organize_imports"
            lsp.ruff_lsp.setup({
                cmd = { "/Users/presley/tools/venvs/main/bin/ruff-lsp" },
                on_attach = function(client, bufnr)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false

                    vim.api.nvim_clear_autocmds({ group = organize_augroup, buffer = bufnr })

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
                        group = organize_augroup,
                        buffer = bufnr,
                        callback = function()
                            perform_code_action_titled("Ruff: Organize Imports")
                        end,
                    })

                    vim.api.nvim_buf_create_user_command(bufnr, "T", function()
                        perform_code_action_titled("Ruff: Fix All")
                    end, { desc = "Fix all" })
                end,
            })

            lsp.rust_analyzer.setup({
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = { command = "clippy" },
                        trace = { server = "verbose" },
                    },
                },
            })

            lsp.clangd.setup({
                on_attach = on_attach,
                settings = { fallbackFlags = { "-std=c++2a" } },
            })

            lsp.gopls.setup({
                on_attach = on_attach,
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            -- This setup is intended for neovim plugins
            lsp.lua_ls.setup({
                on_attach = on_attach,
                settings = {
                    Lua = {
                        format = { enable = false }, -- I use stylua
                        runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        diagnostics = { globals = { "vim" } },
                        telemetry = { enable = false },
                    },
                },
            })
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
    { "folke/neodev.nvim", opts = {}, priority = 1000 }, -- must come before lsp config

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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            local fzf = require("fzf-lua")

            require("which-key").register({
                ["<leader>f"] = { name = "[F]zf", _ = "which_key_ignore" },
            })

            vim.api.nvim_create_user_command("Fzf", fzf.resume, {})

            vim.keymap.set({ "n" }, "<leader>fa", function()
                fzf.lsp_code_actions()
            end, { desc = "[F]zf: Code [A]ction" })
            vim.keymap.set({ "n" }, "<leader>fb", function()
                fzf.lsp_document_symbols()
            end, { desc = "[F]zf: [B]uffers" })
            vim.keymap.set({ "n" }, "<leader>fd", function()
                fzf.lsp_document_symbols()
            end, { desc = "[F]zf: [D]ocument Symbols" })
            vim.keymap.set({ "n" }, "<leader>fw", function()
                fzf.lsp_workspace_symbols()
            end, { desc = "[F]zf: [W]orkspace Symbols" })

            vim.api.nvim_create_user_command("Rg", function(arg)
                fzf.live_grep_native({ search = arg.args })
            end, { nargs = "*" })

            vim.keymap.set({ "n" }, "<leader>rg", fzf.live_grep_native, { silent = true })

            -- like s.strip() in python
            local function strip(s)
                return (s:gsub("^%s*(.-)%s*$", "%1"))
            end

            vim.keymap.set({ "v" }, "<leader>rg", function()
                fzf.live_grep_native({
                    search = strip(fzf.utils.get_visual_selection()),
                })
            end, { silent = true })

            local function get_hash()
                -- The get_hash() is utilised to create an independent "store"
                -- By default `fre --add` adds to global history, in order to restrict this to
                -- current directory we can create a hash which will keep history separate.
                local hash = vim.fn.system("pwd | md5")
                -- for linux, use vim.fn.system("pwd | md5sum | awk '{print $1}'")
                vim.print(hash)
                return hash
            end

            local function fzf_mru(opts)
                opts = fzf.config.normalize_opts(opts, fzf.config.globals.files)

                local fre = "fre --store_name " .. get_hash()
                local no_dups = [[awk '!x[$0]++']] -- remove dups, but keep order
                -- todo: not sure why i need the zsh call here?
                opts.cmd = [[zsh -c "cat <(]] .. fre .. [[ --sorted) <(rg --files)" | ]] .. no_dups

                opts.fzf_opts = vim.tbl_extend("force", opts.fzf_opts, {
                    ["--tiebreak"] = "index", -- make sure that items towards top are from history
                })
                opts.actions = vim.tbl_extend("force", opts.actions or {}, {
                    ["ctrl-d"] = {
                        -- Ctrl-d to remove from history
                        function(sel)
                            if #sel < 1 then
                                return
                            end
                            vim.fn.system(fre .. " --delete " .. sel[1])
                        end,
                        -- This will refresh the list
                        fzf.actions.resume,
                    },
                })

                fzf.core.fzf_wrap(opts, opts.cmd, function(selected)
                    if not selected or #selected < 2 then
                        return
                    end
                    vim.fn.system(fre .. " --add " .. selected[2])
                    fzf.actions.act(opts.actions, selected, opts)
                end)()
            end

            vim.api.nvim_create_user_command("FzfMru", fzf_mru, {})
            vim.keymap.set("n", "<C-p>", fzf_mru, { desc = "Open Files" })

            -- also, need to install: rg, fre - maybe
            fzf.setup({})
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
    { -- terminal (<C-\>)
        "akinsho/toggleterm.nvim",
        event = "VeryLazy",
        opts = { open_mapping = [[<C-\>]] },
    },

    -- Git
    { "tpope/vim-fugitive", event = "VeryLazy" },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "≃" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ "n", "v" }, "]g", function()
                    if vim.wo.diff then
                        return "]g"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to next hunk" })

                map({ "n", "v" }, "[g", function()
                    if vim.wo.diff then
                        return "[g"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to previous hunk" })

                -- Hunk Actions
                -- visual mode
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "stage git hunk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "reset git hunk" })
                -- normal mode
                map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })

                -- Git Actions
                map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
                map("n", "<leader>gD", function()
                    gs.diffthis("~")
                end, { desc = "git Diff against last commit" })
                map("n", "<leader>gm", function()
                    gs.blame_line({ full = false })
                end, { desc = "git blame line" })
                map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })

                -- Toggles
                map(
                    "n",
                    "<leader>tb",
                    gs.toggle_current_line_blame,
                    { desc = "toggle git blame line" }
                )
                map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

                -- Text object
                map({ "o", "x" }, "ih", function()
                    vim.cmd.Gitsigns("select hunk")
                end, { desc = "select git hunk" })
            end,
        },
    },
})

-- Editor Config
-- General
vim.o.undofile = true -- Enable persistent undo (see also `:h undodir`)

vim.o.backup = false -- Don't store backup while overwriting the file
vim.o.writebackup = false -- Don't store backup while overwriting the file

vim.o.mouse = "a" -- Enable mouse for all available modes

-- Appearance
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.cursorline = true -- Highlight current line
vim.o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.number = true -- Show line number on current line
vim.o.relativenumber = true -- Relative line numbers
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitright = true -- Vertical splits will be to the right

vim.o.signcolumn = "yes" -- Always show sign column (otherwise it will shift text)
vim.o.fillchars = "eob: " -- Don't show `~` outside of buffer

-- Editing
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch = true -- Show search results while typing
vim.o.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.o.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent = true -- Make indenting smart

-- Tabs
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.o.softtabstop = 4 -- Number of spaces that <Tab> counts for while performing editing operations
vim.o.tabstop = 4 -- When forced to use tab, make it this wide

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

-- Mappings
local opts = { silent = true }

-- navigation
vim.keymap.set({ "n", "v" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ "n", "v" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
vim.keymap.set({ "n", "v" }, "<left>", "<C-w>h", opts)
vim.keymap.set({ "n", "v" }, "<down>", "<C-w>j", opts)
vim.keymap.set({ "n", "v" }, "<up>", "<C-w>k", opts)
vim.keymap.set({ "n", "v" }, "<right>", "<C-w>l", opts)
vim.keymap.set({ "n", "v" }, "<S-left>", "<C-w>H", opts)
vim.keymap.set({ "n", "v" }, "<S-down>", "<C-w>J", opts)
vim.keymap.set({ "n", "v" }, "<S-up>", "<C-w>K", opts)
vim.keymap.set({ "n", "v" }, "<S-right>", "<C-w>L", opts)

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+y$', opts)

-- a" includes whitespace, 2i" does not
for _, delimiter in ipairs({ "'", "`", '"' }) do
    vim.keymap.set({ "o", "v" }, "a" .. delimiter, "2i" .. delimiter)
end

-- drop highlight on these, since mini.cursorword already highlights current word
vim.keymap.set({ "n", "v" }, "*", "*:noh<CR>", opts)
vim.keymap.set({ "n", "v" }, "#", "#:noh<CR>", opts)

vim.keymap.set({ "n", "v" }, "<tab>", vim.cmd.bnext, opts)
vim.keymap.set({ "n", "v" }, "<S-tab>", vim.cmd.bprevious, opts)

vim.keymap.set({ "n", "v" }, "<enter>", "<C-]>", opts)

vim.keymap.set({ "n", "v" }, "<leader><leader>", vim.cmd.noh, opts)
