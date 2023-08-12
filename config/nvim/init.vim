set nocompatible
let g:python3_host_prog="/Users/presley/tools/venvs/main/bin/python"
let g:python_version=310

let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

"Aesthetics
"""""""""""

" my favorite color scheme currently
Plug 'joshdick/onedark.vim'

" powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" cool start thing
Plug 'mhinz/vim-startify'

" better terminal
Plug 'Lenovsky/nuake', {'on': 'Nuake'}

"General Editing
""""""""""""""""

" some must haves
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
" make :bd work more reasonably
Plug 'qpkorr/vim-bufkill'

" fast fuzzy find
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'

"Programming
""""""""""""

" a lot of syntax files
Plug 'sheerun/vim-polyglot'

" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'dbakker/vim-projectroot'
Plug 'rhysd/git-messenger.vim'
Plug 'rust-lang/rust.vim'

Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/a.vim', {'for': 'cpp'}

Plug 'psf/black', { 'branch': 'stable' }

" COC stuff
Plug 'neoclide/coc.nvim', {'branch' : 'release'}
let g:coc_node_path='/opt/homebrew/bin/node'
let g:coc_global_extensions=[
            \'coc-clangd',
            \'coc-git',
            \'coc-json',
            \'coc-lists',
            \'coc-marketplace',
            \'coc-pyright',
            \'coc-rust-analyzer',
            \'coc-yank',]


call plug#end()

"""""""""""""""""
" Editor Config "
"""""""""""""""""

set termguicolors
filetype plugin on

colorscheme onedark

map <Space> <Leader>

set ignorecase " for searches
set smartcase " for searches
set hlsearch " highlight search matches

set hidden " don't abandon invisible buffers

set number " line numbers

" mouse in edit mode only
set mouse=r

set expandtab      " tabs -> spaces
set tabstop=4      " tabs = 4 spaces
set shiftwidth=4   " >> = 4 spaces
set cindent        " indent for c syntax
set cinoptions+=g2 " scope declarations by 2
set cinoptions+=h2 " statements after scope decs by 2
set smartindent

set updatetime=300 " send CursorHold event after 300ms

if exists('+colorcolumn')
    set colorcolumn=100
    hi ColorColumn ctermbg=darkgrey guibg=#080808
endif

au BufRead,BufNewFile *.{c,cpp,cc,h} set filetype=cpp
let g:alternateExtensions_cc='h'
let g:alternateExtensions_h='cc,c,cpp'

" use the alt key as meta on mac
if has("gui_macvim")
    set macmeta
endif

"""""""""""""""
"Plugin Config"
"""""""""""""""

let g:airline_theme='onedark'

let g:airline_powerline_fonts=1
let g:airline_inactive_collapse=1
let g:airline_skip_empty_sections=1
let g:airline_highlighting_cache=1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" No encoding info
let g:airline_section_y=''

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(), 0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(), 0)}'

let g:fzf_layout= {'window':{'width': 0.9, 'height' : 0.6}}

nmap <leader>ll :CocList lists<cr>
nmap <leader>lc :CocList commands<cr>

nmap <leader>b :CocList --top buffers<cr>
nmap <leader>lb :CocList --top lines<cr>

nmap <leader>f :GFiles<cr>
nmap <leader>c :Commits!<cr>
nmap <leader>cb :BCommits!<cr>

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" quick fix
nmap <leader>qf <Plug>(coc-fix-current)

" navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gl <Plug>(coc-codelense-action)

" navigate git things
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nmap gs <Plug>(coc-git-chunkinfo)
nmap go <Plug>(coc-git-commit)

" show documentation in preview window
function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

autocmd BufWrite *.rs call CocAction('format')

""""""""""""""""
" clang_format "
""""""""""""""""
let g:clang_format#auto_format_on_insert_leave = 0
let g:clang_format#auto_format = 1
let g:clang_format#auto_formatexpr = 0

"""""""""""""""""
" other plugins "
"""""""""""""""""

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1

nnoremap <silent> <C-P> :GFiles<CR>
nnoremap <silent> <leader>t :Nuake<CR>

""""""""""""
" My Stuff "
""""""""""""
highlight Comment cterm=italic gui=italic
set fcs=eob:\
set inccommand=nosplit

set splitbelow " :sp goes below
set splitright " :vs goes right

" space-space resets syntax highlighting and regular highlighting
nnoremap <silent> <leader><space> :silent noh <Bar>echo<cr>:syn sync fromstart<cr>

" flash bracket match on screen
set showmatch
set matchtime=2
let g:matchparen_timeout = 20
let g:matchparen_insert_timeout = 20

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
