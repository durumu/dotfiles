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
    -- { --colorscheme
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000, -- load before other plugins
    --     config = function()
    --         require("tokyonight").setup({
    --             style = "moon", -- bg=dark
    --             light_style = "day", -- bg=light
    --             styles = {
    --                 -- Style to be applied to different syntax groups
    --                 -- Value is any valid attr-list value for `:help nvim_set_hl`
    --                 comments = { italic = true },
    --                 keywords = { italic = false },
    --                 functions = {},
    --                 variables = {},
    --                 -- Background styles. Can be "dark", "transparent" or "normal"
    --                 sidebars = "dark", -- style for sidebars, see below
    --                 floats = "dark", -- style for floating windows
    --             },
    --             sidebars = { "qf", "help", "terminal" }, -- darker background on sidebars
    --             lualine_bold = true, -- section headers in the lualine theme will be bold
    --         })
    --         vim.cmd([[colorscheme tokyonight]])
    --     end,
    -- },
    { -- colorscheme
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme onedark]])
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
            vim.g.startify_enable_special = 0
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

    -- Text objects
    { -- if/af
        "kana/vim-textobj-function",
        dependencies = { "kana/vim-textobj-user" },
    },
    { -- ie/ae
        "kana/vim-textobj-entire",
        dependencies = { "kana/vim-textobj-user" },
    },
    { -- i,/a,
        "sgur/vim-textobj-parameter",
        dependencies = { "kana/vim-textobj-user" },
    },
    { -- iv/av
        "julian/vim-textobj-variable-segment",
        dependencies = { "kana/vim-textobj-user" },
    },
    { -- ic/ac
        "glts/vim-textobj-comment",
        dependencies = { "kana/vim-textobj-user" },
    },

    -- Projects
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
            { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree", mode = { "n", "v" } },
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
                "coc-pairs",
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

            -- mappings
            local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
            function _G.check_back_space()
                local col = vim.fn.col(".") - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
            end

            vim.keymap.set(
                "i",
                "<TAB>",
                [[coc#pum#visible() ? coc#pum#next(1) : v:lua._G.check_back_space() ? "<TAB>" : coc#refresh()]],
                opts
            )
            vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

            -- Make <CR> to accept selected completion item or notify coc.nvim to format
            -- <C-g>u breaks current undo, please make your own choice
            vim.keymap.set(
                "i",
                "<cr>",
                [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
                opts
            )

            -- lists
            vim.keymap.set({ "n", "v" }, "<leader>ll", "<cmd>CocList lists<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>lc", "<cmd>CocList commands<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>lb", "<cmd>CocList --top buffers<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>ly", "<cmd>CocList --A --normal yank<cr>")

            -- navigate diagnostics
            vim.keymap.set({ "n", "v" }, "[d", "<Plug>(coc-diagnostic-prev)")
            vim.keymap.set({ "n", "v" }, "]d", "<Plug>(coc-diagnostic-next)")

            -- other coc mappings
            vim.keymap.set({ "n", "v" }, "gd", "<Plug>(coc-definition)")
            vim.keymap.set({ "n", "v" }, "gi", "<Plug>(coc-implementation)")
            vim.keymap.set({ "n", "v" }, "gl", "<Plug>(coc-codelense-action)")
            vim.keymap.set({ "n", "v" }, "gr", "<Plug>(coc-references)")
            vim.keymap.set({ "n", "v" }, "gy", "<Plug>(coc-type-definition)")

            vim.keymap.set({ "n", "v" }, "<leader>qf", "<Plug>(coc-fix-current)")

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
        "psf/black",
        ft = { "python" },
        branch = "stable",
        config = function()
            vim.g.black_virtualenv = "~/tools/venvs/main"
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.py" },
                callback = function()
                    vim.cmd([[Black]])
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
