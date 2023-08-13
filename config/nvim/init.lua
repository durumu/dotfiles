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

local function coc_config()
    vim.g.coc_node_path = "/opt/homebrew/bin/node"
    vim.g.coc_global_extensions = {
        "coc-clangd",
        "coc-explorer",
        "coc-git",
        "coc-json",
        "coc-lists",
        "coc-marketplace",
        "coc-pyright",
        "coc-rust-analyzer",
        "coc-yank",
    }

    vim.keymap.set("n", "<leader>ll", ":CocList lists<cr>")
    vim.keymap.set("n", "<leader>lc", ":CocList commands<cr>")
    vim.keymap.set("n", "<leader>lb", ":CocList --top buffers<cr>")
    vim.keymap.set("i", "<c-space>", "coc#refresh()")
    vim.keymap.set("i", "<cr>", function()
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
    vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)")

    -- navigate diagnostics
    vim.keymap.set("n", "[d", "<Plug>(coc-diagnostic-prev)")
    vim.keymap.set("n", "]d", "<Plug>(coc-diagnostic-next)")

    -- other coc mappings
    vim.keymap.set("n", "gd", "<Plug>(coc-definition)")
    vim.keymap.set("n", "gi", "<Plug>(coc-implementation)")
    vim.keymap.set("n", "gl", "<Plug>(coc-codelense-action)")
    vim.keymap.set("n", "gr", "<Plug>(coc-references)")
    vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)")

    -- navigate git things
    vim.keymap.set("n", "[g", "<Plug>(coc-git-prevchunk)")
    vim.keymap.set("n", "]g", "<Plug>(coc-git-nextchunk)")
    vim.keymap.set("n", "go", "<Plug>(coc-git-commit)")
    vim.keymap.set("n", "gs", "<Plug>(coc-git-chunkinfo)")

    -- documentation
    local function show_documentation()
        local filetype = vim.bo.filetype
        if filetype == "vim" or filetype == "help" then
            vim.cmd("h " .. vim.fn.expand("<cword>"))
        else
            vim.call("CocAction", "doHover")
        end
    end
    vim.keymap.set("n", "K", show_documentation)
end

local function in_git_repo()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    local result = handle:read("*a")
    handle:close()

    -- Trim the result
    result = string.gsub(result, "^%s*(.-)%s*$", "%1")

    return result == "true"
end

require("lazy").setup({
    -- Essential
    {
        "navarasu/onedark.nvim",
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
    { -- make . work with other tpope plugins
        "tpope/vim-repeat",
    },
    { -- cs/ds/ys
        "tpope/vim-surround",
    },
    { -- gc
        "tpope/vim-commentary",
    },
    { -- []
        "tpope/vim-unimpaired",
    },
    { -- :BD
        "qpkorr/vim-bufkill",
        cmd = "BD",
    },
    { "vim-scripts/ShowTrailingWhitespace" },
    {
        "vim-scripts/DeleteTrailingWhitespace",
        config = function()
            vim.g.DeleteTrailingWhitespace = 1
            vim.g.DeleteTrailingWhitespace_Action = "delete"
        end,
    },

    -- Projects
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        horizontal = { height = 0.8, width = 0.9 },
                        vertical = { height = 0.8, width = 0.9 },
                    },
                },
            })
            vim.keymap.set("n", "<C-P>", function()
                if in_git_repo() then
                    require("telescope.builtin").git_files()
                else
                    require("telescope.builtin").find_files()
                end
            end)
            vim.keymap.set("n", "<leader>g", function()
                require("telescope.builtin").live_grep()
            end)
            vim.keymap.set("v", "<leader>g", function()
                require("telescope.builtin").grep_string()
            end)
        end,
    },
    { -- :G
        "tpope/vim-fugitive",
    },
    { -- :GitMessenger
        "rhysd/git-messenger.vim",
        cmd = "GitMessenger",
    },

    -- Programming
    {
        "neoclide/coc.nvim",
        ft = { "c", "cpp", "python", "rust" },
        branch = "release",
        config = coc_config,
    },
    { -- :A
        "vim-scripts/a.vim",
        cmd = "A",
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

    -- Productivity
    { "Lenovsky/nuake", cmd = "Nuake" }, -- terminal
    {
        "dpayne/CodeGPT.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        cmd = "Chat",
    }, -- :Chat
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
local function keymap_nv(key, action)
    local options = { noremap = true, silent = true }
    vim.keymap.set("n", key, action, options)
    vim.keymap.set("v", key, action, options)
end

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

keymap_nv("<leader><space>", ":noh<cr>")
keymap_nv("<leader>bd", ":BD")
keymap_nv("<leader>t", ":Nuake<cr>")
keymap_nv("<leader>y", '"+y')
keymap_nv("<leader>Y", '"+y$')

-- Commands
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("X", "x", {})
