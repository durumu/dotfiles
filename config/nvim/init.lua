-- Non-Compatibility mode
vim.o.compatible = false
vim.g.python3_host_prog = "/Users/presley/tools/venvs/main/bin/python"
vim.g.python_version = 310

-- Set the data directory path
local data_dir = vim.fn.stdpath('data') .. '/site'

-- Function: Get the data directory path
local function get_data_dir()
    return data_dir
end

if vim.fn.empty(vim.fn.glob(data_dir .. '/autoload/plug.vim')) == 1 then
    vim.cmd('!curl -fLo ' .. data_dir .. '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end

vim.cmd([[
    call plug#begin()

    " Aesthetics
    Plug 'joshdick/onedark.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-startify'
    Plug 'Lenovsky/nuake', {'on': 'Nuake'}

    " General Editing
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-unimpaired'
    Plug 'qpkorr/vim-bufkill'
    Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
    Plug 'junegunn/fzf.vim'

    " Programming
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-fugitive'
    Plug 'dbakker/vim-projectroot'
    Plug 'rhysd/git-messenger.vim'
    Plug 'rust-lang/rust.vim'
    Plug 'rhysd/vim-clang-format'
    Plug 'vim-scripts/a.vim', {'for': 'cpp'}
    Plug 'psf/black', { 'branch': 'stable' }
    Plug 'nvim-lua/plenary.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'dpayne/CodeGPT.nvim'

    " COC stuff
    Plug 'neoclide/coc.nvim', {'branch' : 'release'}

    call plug#end()
]])

vim.g.coc_node_path = '/opt/homebrew/bin/node'
vim.g.coc_global_extensions = {
    'coc-clangd',
    'coc-git',
    'coc-json',
    'coc-lists',
    'coc-marketplace',
    'coc-pyright',
    'coc-rust-analyzer',
    'coc-yank',
}

-- Editor Config
vim.o.termguicolors = true
vim.cmd('filetype plugin on')
vim.cmd('colorscheme onedark')
vim.g.mapleader = ' '
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.hidden = true
vim.wo.number = true
vim.o.mouse = 'r'
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cindent = true
vim.o.cinoptions = vim.o.cinoptions .. 'g2'
vim.o.cinoptions = vim.o.cinoptions .. 'h2'
vim.o.smartindent = true
vim.o.updatetime = 300

if vim.fn.exists('+colorcolumn') == 1 then
    vim.o.colorcolumn = '100'
    vim.cmd('hi ColorColumn ctermbg=darkgrey guibg=#080808')
end

vim.cmd([[
    au BufRead,BufNewFile *.{c,cpp,cc,h} set filetype=cpp
]])

vim.g.alternateExtensions_cc = 'h'
vim.g.alternateExtensions_h = 'cc,c,cpp'

if vim.fn.has("gui_macvim") == 1 then
    vim.o.macmeta = true
end

-- Plugin Config
vim.g.airline_theme = 'onedark'
vim.g.airline_powerline_fonts = 1
vim.g.airline_inactive_collapse = 1
vim.g.airline_skip_empty_sections = 1
vim.g.airline_highlighting_cache = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#left_sep"] = ' '
vim.g["airline#extensions#tabline#left_alt_sep"] = '|'
vim.g.airline_section_y = ''
vim.g.airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(), 0)}'
vim.g.airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(), 0)}'
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

-- clang_format
vim.g["clang_format#auto_format_on_insert_leave"] = 0
vim.g["clang_format#auto_format"] = 1
vim.g["clang_format#auto_formatexpr"] = 0

-- other plugins
vim.g.startify_change_to_dir = 0
vim.g.startify_change_to_vcs_root = 1

-- My Stuff
vim.cmd('highlight Comment cterm=italic gui=italic')
vim.o.fcs = 'eob:\\'
vim.o.inccommand = 'nosplit'
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
