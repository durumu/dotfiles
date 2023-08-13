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

require("lazy").setup({
	-- Aesthetics
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
			vim.g.airline_section_error = "%{airline#util#wrap(airline#extensions#coc#get_error(), 0)}"
			vim.g.airline_section_warning = "%{airline#util#wrap(airline#extensions#coc#get_warning(), 0)}"
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

	-- General Editing
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"tpope/vim-commentary",
	"tpope/vim-unimpaired",
	"qpkorr/vim-bufkill", -- make :bd work more reliably

	-- Projects
	{ "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
	{
		"junegunn/fzf.vim",
		config = function()
			vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
		end,
	},
	"tpope/vim-fugitive", -- :G
	"rhysd/git-messenger.vim", -- :GitMessenger

	-- Programming
	{ "neoclide/coc.nvim", ft = { "c", "cpp", "python", "rust" }, branch = "release" }, -- COC
	{ "vim-scripts/a.vim", ft = { "c", "cpp" } }, -- :A
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
	"mhinz/vim-startify", -- start page
	{ "Lenovsky/nuake", cmd = "Nuake" }, -- terminal
	"nvim-lua/plenary.nvim", -- needed for CodeGPT
	"MunifTanjim/nui.nvim", -- needed for CodeGPT
	"dpayne/CodeGPT.nvim", -- :Chat
})

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

-- Editor Config
vim.cmd([[filetype plugin on]])
vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. "g2"
vim.o.cinoptions = vim.o.cinoptions .. "h2"
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.mouse = "r"
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.wo.number = true

vim.o.colorcolumn = "88"
vim.cmd([[highlight ColorColumn ctermbg=darkgrey guibg=#080808]])

-- vim.cmd([[
--     au BufRead,BufNewFile *.{c,cpp,cc,h} set filetype=cpp
-- ]])

-- vim.g.alternateExtensions_cc = "h"
-- vim.g.alternateExtensions_h = "cc,c,cpp"

-- startify
vim.g.startify_change_to_dir = 0
vim.g.startify_change_to_vcs_root = 1

-- My Stuff
vim.cmd("highlight Comment cterm=italic gui=italic")
vim.o.fcs = "eob:\\"
vim.o.inccommand = "nosplit"
vim.o.splitbelow = true
vim.o.splitright = true

-- Mappings
local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<C-P>", ":GFiles<CR>", options)
vim.api.nvim_set_keymap("n", "<leader>t", ":Nuake<CR>", options)
vim.api.nvim_set_keymap("n", "<leader><space>", ":noh<CR>", options)

vim.api.nvim_set_keymap("n", "Q", "@q", options)
vim.api.nvim_set_keymap("n", "Y", "y$", options)

vim.api.nvim_set_keymap("n", "j", "gj", options)
vim.api.nvim_set_keymap("n", "k", "gk", options)

vim.api.nvim_set_keymap("n", "<left>", "<C-w>h", options)
vim.api.nvim_set_keymap("n", "<down>", "<C-w>j", options)
vim.api.nvim_set_keymap("n", "<up>", "<C-w>k", options)
vim.api.nvim_set_keymap("n", "<right>", "<C-w>l", options)
vim.api.nvim_set_keymap("n", "<S-left>", "<C-w>H", options)
vim.api.nvim_set_keymap("n", "<S-down>", "<C-w>J", options)
vim.api.nvim_set_keymap("n", "<S-up>", "<C-w>K", options)
vim.api.nvim_set_keymap("n", "<S-right>", "<C-w>L", options)

vim.api.nvim_set_keymap("n", "<tab>", ":bnext<cr>", options)
vim.api.nvim_set_keymap("n", "<S-tab>", ":bprevious<cr>", options)
vim.api.nvim_set_keymap("n", "<enter>", "<C-]>", options)

local modes = { "n", "v" }
for _, mode in ipairs(modes) do
	vim.api.nvim_set_keymap(mode, "<leader>y", '"+y', options)
	vim.api.nvim_set_keymap(mode, "<leader>Y", '"+y$', options)
end

-- Commands
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("X", "x", {})

-- Autocommands
