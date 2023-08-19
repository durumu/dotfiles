-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.python3_host_prog = "~/tools/venvs/main/bin/python"
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
        config = function()
            require("tokyonight").setup({
                style = "moon", -- bg=dark
                light_style = "day", -- bg=light
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
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
                    icons_enabled = true,
                    component_separators = { left = "│", right = "│" }, -- \u2502
                    section_separators = { left = "", right = "" },
                    theme = "auto",
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = { lualine_a = { "buffers" } },
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
    { -- start page
        "mhinz/vim-startify",
        lazy = false,
        config = function()
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
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

    -- Projects
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- also, need to install: rg, fd, bat
            require("fzf-lua").setup({})
        end,
    },
    { -- :G
        "tpope/vim-fugitive",
    },
    { -- :GitMessenger
        "rhysd/git-messenger.vim",
    },
    { -- file tree
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
            })
        end,
    },

    -- Programming
    {
        "neoclide/coc.nvim",
        branch = "release",
        lazy = false,
        config = function()
            vim.g.coc_node_path = "/opt/homebrew/bin/node"
            vim.g.coc_global_extensions = {
                "coc-clangd",
                "coc-explorer",
                "coc-git",
                "coc-json",
                "coc-lists",
                "coc-lua",
                "coc-marketplace",
                "coc-pyright",
                "coc-rust-analyzer",
                "coc-yank",
            }

            -- Some servers have issues with backup files, see #649
            vim.opt.backup = false
            vim.opt.writebackup = false

            -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
            -- delays and poor user experience
            vim.opt.updatetime = 300

            -- Always show the signcolumn, otherwise it would shift the text each time
            -- diagnostics appeared/became resolved
            vim.opt.signcolumn = "yes"
        end,
    },
    { -- rust
        "rust-lang/rust.vim",
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    -- Autoformat
    { -- c++
        "rhysd/vim-clang-format",
        ft = { "c", "cpp" },
        config = function()
            vim.g["clang_format#auto_format_on_insert_leave"] = 0
            vim.g["clang_format#auto_format"] = 1
            vim.g["clang_format#auto_formatexpr"] = 0
        end,
    },
    { -- python
        "averms/black-nvim",
        ft = { "python" },
        build = ":UpdateRemotePlugins",
        config = function()
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.py" },
                callback = function()
                    Black()
                end,
            })
        end,
    },
    { -- lua
        "ckipp01/stylua-nvim",
        ft = { "lua" },
        config = function()
            require("stylua-nvim").setup({ config_file = "~/.dotfiles/config/stylua.toml" })
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
        lazy = false,
        config = function()
            require("toggleterm").setup({ open_mapping = [[<C-\>]] })
        end,
    },
    { -- :Chat
        "dpayne/CodeGPT.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        cmd = "Chat",
    },
})

-- Editor Config
vim.cmd([[highlight Comment cterm=italic gui=italic]])
vim.cmd([[filetype plugin on]])
vim.cmd([[highlight ColorColumn ctermbg=darkgrey guibg=#080808]])

vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. "g2" .. "h2"
vim.o.colorcolumn = "100"
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

-- Plugin Mappings

-- git-messenger
vim.keymap.set({ "n", "v" }, "<leader>gm", function()
    vim.cmd([[GitMessenger]])
end)

-- nvim-tree
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    vim.cmd([[NvimTreeToggle]])
end)

-- fzf-lua
vim.keymap.set({ "n", "v" }, "<C-p>", function()
    require("fzf-lua").files()
end, { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>g", function()
    require("fzf-lua").grep()
end, { silent = true })

-- coc
local opts = { expr = true, noremap = true, silent = true, replace_keycodes = false }
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "<CR>"]], opts)
vim.keymap.set("i", "<C-space>", "coc#refresh()", opts)

vim.keymap.set({ "n", "v" }, "<leader>ll", ":CocList lists<cr>")
vim.keymap.set({ "n", "v" }, "<leader>lc", ":CocList commands<cr>")
vim.keymap.set({ "n", "v" }, "<leader>lb", ":CocList --top buffers<cr>")
vim.keymap.set({ "n", "v" }, "<leader>qf", "<Plug>(coc-fix-current)")

-- navigate diagnostics
vim.keymap.set({ "n", "v" }, "[d", "<Plug>(coc-diagnostic-prev)")
vim.keymap.set({ "n", "v" }, "]d", "<Plug>(coc-diagnostic-next)")

-- other coc mappings
vim.keymap.set({ "n", "v" }, "gd", "<Plug>(coc-definition)")
vim.keymap.set({ "n", "v" }, "gi", "<Plug>(coc-implementation)")
vim.keymap.set({ "n", "v" }, "gl", "<Plug>(coc-codelense-action)")
vim.keymap.set({ "n", "v" }, "gr", "<Plug>(coc-references)")
vim.keymap.set({ "n", "v" }, "gy", "<Plug>(coc-type-definition)")

-- navigate git things
vim.keymap.set({ "n", "v" }, "[g", "<Plug>(coc-git-prevchunk)")
vim.keymap.set({ "n", "v" }, "]g", "<Plug>(coc-git-nextchunk)")
vim.keymap.set({ "n", "v" }, "go", "<Plug>(coc-git-commit)")
vim.keymap.set({ "n", "v" }, "gs", "<Plug>(coc-git-chunkinfo)")

-- documentation
local function show_documentation()
    local filetype = vim.bo.filetype
    if filetype == "vim" or filetype == "help" then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    else
        vim.call("CocAction", "doHover")
    end
end
vim.keymap.set({ "n", "v" }, "K", show_documentation)

-- Command
vim.api.nvim_create_user_command("Q", "qall", {})
vim.api.nvim_create_user_command("W", "wall", {})
vim.api.nvim_create_user_command("X", "xall", {})

-- delete trailing whitespace
function delete_trailing_whitespace()
    local current_pos = vim.api.nvim_win_get_cursor(0) -- Save current cursor position

    -- Execute the substitution command across the whole buffer to remove trailing whitespace
    vim.api.nvim_command(":%s/\\s\\+$//e")

    vim.api.nvim_win_set_cursor(0, current_pos) -- Restore cursor position
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
        delete_trailing_whitespace()
    end,
})
