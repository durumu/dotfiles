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
	"joshdick/onedark.vim",
	"vim-airline/vim-airline",
	"vim-airline/vim-airline-themes",

	-- General Editing
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"tpope/vim-commentary",
	"tpope/vim-unimpaired", --
	"qpkorr/vim-bufkill", -- make :bd work more reliably

	-- Projects
	{ "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
	"junegunn/fzf.vim",
	"tpope/vim-fugitive",
	"rhysd/git-messenger.vim", -- :GitMessenger

	-- Programming
	{ "neoclide/coc.nvim", branch = "release" }, -- COC
	"sheerun/vim-polyglot", -- many-language syntax
	{ "vim-scripts/a.vim", ft = "cpp" }, -- :A
	{ "psf/black", ft = "py", branch = "stable" }, -- python autoformat
	{ "rhysd/vim-clang-format", ft = "cpp" }, -- c++ autoformat
	{ "rust-lang/rust.vim", ft = "rs" }, -- rust syntax

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
vim.o.termguicolors = true
vim.cmd("filetype plugin on")
vim.cmd("colorscheme onedark")
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.hidden = true
vim.wo.number = true
vim.o.mouse = "r"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. "g2"
vim.o.cinoptions = vim.o.cinoptions .. "h2"
vim.o.smartindent = true
vim.o.updatetime = 300

if vim.fn.exists("+colorcolumn") == 1 then
	vim.o.colorcolumn = "100"
	vim.cmd("hi ColorColumn ctermbg=darkgrey guibg=#080808")
end

vim.cmd([[
    au BufRead,BufNewFile *.{c,cpp,cc,h} set filetype=cpp
]])

vim.g.alternateExtensions_cc = "h"
vim.g.alternateExtensions_h = "cc,c,cpp"

if vim.fn.has("gui_macvim") == 1 then
	vim.o.macmeta = true
end

-- Plugin Config
vim.g.airline_theme = "onedark"
vim.g.airline_powerline_fonts = 1
vim.g.airline_inactive_collapse = 1
vim.g.airline_skip_empty_sections = 1
vim.g.airline_highlighting_cache = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#left_sep"] = " "
vim.g["airline#extensions#tabline#left_alt_sep"] = "|"
vim.g.airline_section_y = ""
vim.g.airline_section_error = "%{airline#util#wrap(airline#extensions#coc#get_error(), 0)}"
vim.g.airline_section_warning = "%{airline#util#wrap(airline#extensions#coc#get_warning(), 0)}"
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

-- clang_format
vim.g["clang_format#auto_format_on_insert_leave"] = 0
vim.g["clang_format#auto_format"] = 1
vim.g["clang_format#auto_formatexpr"] = 0

-- other plugins
vim.g.startify_change_to_dir = 0
vim.g.startify_change_to_vcs_root = 1

-- My Stuff
vim.cmd("highlight Comment cterm=italic gui=italic")
vim.o.fcs = "eob:\\"
vim.o.inccommand = "nosplit"
vim.o.splitbelow = true
vim.o.splitright = true

vim.cmd([[
    nnoremap <silent> <C-P> :GFiles<CR>
    nnoremap <silent> <leader>t :Nuake<CR>

    " space-space resets syntax highlighting and regular highlighting
    nnoremap <silent> <leader><space> :silent noh <Bar>echo<cr>:syn sync fromstart<cr>

    command! Q q
    command! W w
    command! X x

    nnoremap Q @q

    nnoremap Y y$

    " navigation
    nnoremap <silent> j gj
    nnoremap <silent> k gk

    nnoremap <silent> <left> <C-w>h
    nnoremap <silent> <down> <C-w>j
    nnoremap <silent> <up> <C-w>k
    nnoremap <silent> <right> <C-w>l

    nnoremap <silent> <S-left> <C-w>H
    nnoremap <silent> <S-down> <C-w>J
    nnoremap <silent> <S-up> <C-w>K
    nnoremap <silent> <S-right> <C-w>L

    nnoremap <silent> <tab> :bnext<cr>
    nnoremap <silent> <S-tab> :bprevious<cr>

    nnoremap <silent> <enter> <C-]>


    noremap <leader>y "+y
    noremap <leader>Y "+y$

    augroup black_on_save
        autocmd!
        autocmd BufWritePre *.py Black
    augroup end
]])

-- You'll need to further translate the function, autocmds, and remaps.
