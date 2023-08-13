vim.g.python3_host_prog = "~/tools/venvs/main/bin/python"
vim.g.python_version = 311

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

vim.g.mapleader = " "

local function keymap(mode, key, action)
    local options = { noremap = true, silent = true }
    vim.api.nvim_set_keymap(mode, key, action, options)
end

local function keymap_nv(key, action)
    keymap("n", key, action)
    keymap("v", key, action)
end

local function coc_config()
    vim.g.coc_node_path = "/opt/homebrew/bin/node"
    vim.g.coc_global_extensions = {
        "coc-clangd",
        "coc-git",
        "coc-json",
        "coc-lists",
        "coc-marketplace",
        "coc-pyright",
        "coc-rust-analyzer",
        "coc-yank",
    }

    keymap("n", "<leader>ll", ":CocList lists<cr>")
    keymap("n", "<leader>lc", ":CocList commands<cr>")
    keymap("n", "<leader>lb", ":CocList --top buffers<cr>")
    keymap("n", "<leader>c", ":Commits!<cr>")
    keymap("n", "<leader>cb", ":BCommits!<cr>")
    keymap("i", "<c-space>", "coc#refresh()")
    keymap("i", "<cr>", function()
        if vim.fn.pumvisible() == 1 then
            return vim.call("coc#select_confirm")
        else
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-g>u", true, true, true),
                "n",
                true
            )
            return vim.call("coc#on_enter")
        end
    end)

    -- quick fix
    keymap("n", "<leader>qf", "<Plug>(coc-fix-current)")

    -- navigate diagnostics
    keymap("n", "[d", "<Plug>(coc-diagnostic-prev)")
    keymap("n", "]d", "<Plug>(coc-diagnostic-next)")

    -- other coc mappings
    keymap("n", "gd", "<Plug>(coc-definition)")
    keymap("n", "gy", "<Plug>(coc-type-definition)")
    keymap("n", "gi", "<Plug>(coc-implementation)")
    keymap("n", "gr", "<Plug>(coc-references)")
    keymap("n", "gl", "<Plug>(coc-codelense-action)")

    -- navigate git things
    keymap("n", "[g", "<Plug>(coc-git-prevchunk)")
    keymap("n", "]g", "<Plug>(coc-git-nextchunk)")
    keymap("n", "gs", "<Plug>(coc-git-chunkinfo)")
    keymap("n", "go", "<Plug>(coc-git-commit)")
end

require("lazy").setup({
    -- Essential
    {
        "joshdick/onedark.vim",
        lazy = false,
        config = function()
            vim.cmd([[colorscheme onedark]])
        end,
    },
    {
        "vim-airline/vim-airline",
        lazy = false,
        config = function()
            vim.g.airline_highlighting_cache = 1
            vim.g.airline_inactive_collapse = 1
            vim.g.airline_powerline_fonts = 1
            vim.g.airline_section_error =
                "%{airline#util#wrap(airline#extensions#coc#get_error(), 0)}"
            vim.g.airline_section_warning =
                "%{airline#util#wrap(airline#extensions#coc#get_warning(), 0)}"
            vim.g.airline_section_y = ""
            vim.g.airline_skip_empty_sections = 1
            vim.g["airline#extensions#tabline#enabled"] = 1
            vim.g["airline#extensions#tabline#left_alt_sep"] = "|"
            vim.g["airline#extensions#tabline#left_sep"] = " "
        end,
    },
    {
        "vim-airline/vim-airline-themes",
        lazy = false,
        config = function()
            vim.g.airline_theme = "onedark"
        end,
    },
    {
        "mhinz/vim-startify",
        lazy = false,
        config = function()
            vim.g.startify_change_to_dir = 0
            vim.g.startify_change_to_vcs_root = 1
        end,
    },

    -- General Editing
    "tpope/vim-repeat", -- make . work with other tpope plugins
    "tpope/vim-surround",
    "tpope/vim-commentary", -- gc verb
    "tpope/vim-unimpaired", --
    { "qpkorr/vim-bufkill", cmd = "BD" },

    -- Projects
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    {
        "junegunn/fzf.vim",
        config = function()
            vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
            keymap_nv("<C-P>", ":GFiles<CR>")
            keymap("n", "<leader>f", ":GFiles<cr>")
        end,
    },
    "tpope/vim-fugitive", -- :G
    "rhysd/git-messenger.vim", -- :GitMessenger

    -- Programming
    {
        "neoclide/coc.nvim",
        ft = { "c", "cpp", "python", "rust" },
        branch = "release",
        config = coc_config,
    },
    { -- :A
        "vim-scripts/a.vim",
        ft = { "c", "cpp" },
    },
    { -- c++ autoformat
        "rhysd/vim-clang-format",
        ft = { "c", "cpp" },
        config = function()
            vim.g["clang_format#auto_format_on_insert_leave"] = 0
            vim.g["clang_format#auto_format"] = 1
            vim.g["clang_format#auto_formatexpr"] = 0
        end,
    },
    { -- python autoformat
        "averms/black-nvim",
        ft = "python",
        config = function()
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.py" },
                callback = function()
                    Black()
                end,
            })
        end,
    },
    { -- lua autoformat
        "ckipp01/stylua-nvim",
        ft = "lua",
        run = "cargo install stylua",
        config = function()
            require("stylua-nvim").setup({ config_file = "~/.dotfiles/stylua.toml" })
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.lua" },
                callback = function()
                    require("stylua-nvim").format_file()
                end,
            })
        end,
    },
    { "rust-lang/rust.vim", ft = "rust" }, -- rust syntax

    -- Productivity
    { "Lenovsky/nuake", cmd = "Nuake" }, -- terminal
    "nvim-lua/plenary.nvim", -- needed for CodeGPT
    "MunifTanjim/nui.nvim", -- needed for CodeGPT
    "dpayne/CodeGPT.nvim", -- :Chat
})

-- Editor Config
vim.cmd([[highlight Comment cterm=italic gui=italic]])
vim.cmd([[filetype plugin on]])
vim.cmd([[highlight ColorColumn ctermbg=darkgrey guibg=#080808]])

vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. "g2" .. "h2"
vim.o.colorcolumn = "100"
vim.o.expandtab = true
vim.o.fcs = "eob:\\"
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
keymap_nv("Y", "y$")
keymap_nv("j", "gj")
keymap_nv("k", "gk")
keymap_nv("Q", "q")
keymap_nv("q", "@q")

-- navigation
keymap_nv("<left>", "<C-w>h")
keymap_nv("<down>", "<C-w>j")
keymap_nv("<up>", "<C-w>k")
keymap_nv("<right>", "<C-w>l")
keymap_nv("<S-left>", "<C-w>H")
keymap_nv("<S-down>", "<C-w>J")
keymap_nv("<S-up>", "<C-w>K")
keymap_nv("<S-right>", "<C-w>L")
keymap_nv("<tab>", ":bnext<cr>")
keymap_nv("<S-tab>", ":bprevious<cr>")

keymap_nv("<enter>", "<C-]>")

keymap_nv("<leader><space>", ":noh<CR>")
keymap_nv("<leader>bd", ":BD")
keymap_nv("<leader>t", ":Nuake<CR>")
keymap_nv("<leader>y", '"+y')
keymap_nv("<leader>Y", '"+y$')

-- Commands
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("X", "x", {})
