" Julia's .vimrc

"""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""

set nocompatible
execute pathogen#infect()
filetype plugin indent on

"""""""""""""""""""""""""""""
" Editor Settings
"""""""""""""""""""""""""""""

set encoding=utf8
set fileformats=unix

set mouse=c         " mouse only used in command-line mode
set hidden          " don't close files when opening new ones

set cmdheight=2     " command line has height of 2 
set wildmenu        " tab cycles thru commands

"" no bell 
set noerrorbells
" set novisualbell
" set t_vb=
" set tm=500

set backspace=indent,eol,start " make backspace work as expected

set autowrite


"LaTeX-suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_AutoFolding = 0
 
"""""""""""""""""""""""""""""
" Searching
"""""""""""""""""""""""""""""

set smartcase " search is case sensitive if there are uppercase letters
set hlsearch
set incsearch
set nomagic " ., *, etc work as expected -- use \m to do a 'regex'

"""""""""""""""""""""""""""""
" Indent
"""""""""""""""""""""""""""""

set autoindent
set smarttab
set wrap

" 1 tab = 2 spaces
set expandtab
set shiftwidth=2 
set softtabstop=2
" except for Python and LaTeX
autocmd FileType python :set shiftwidth=4 softtabstop=4
autocmd FileType tex :set shiftwidth=4 softtabstop=4

"""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""

syntax on
set number
set ruler
set scrolloff=7

" Match brackets
set showmatch
set matchtime=2
set matchpairs+=<:>
" reduce lag caused by that

let g:matchparen_timeout=20
let g:matchparen_insert_timeout=20

set background=dark
let g:solarized_termtrans=1 " if screen transparent
"set t_Co=256               " if screen not transparent
"let g:solarized_termcolors=256
colorscheme solarized

" Airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'

highlight comment cterm=italic

"""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""

" Y = yank to end of line.
nnoremap Y y$
nnoremap <Space> :set nopaste<cr>:noh<cr>

" arrows!
nnoremap    <Left> :wincmd h <cr> 
nnoremap   <Right> :wincmd l <cr> 
nnoremap      <Up> :wincmd k <cr>
nnoremap    <Down> :wincmd j <cr>
nnoremap  <S-Left> :bnext <cr>
nnoremap <S-Right> :bprev <cr>

" my janky run macros ;_;
autocmd FileType cpp nnoremap <F6> :w <bar> :make %:r <bar> :!./%:r < %:r.dat <cr>
autocmd FileType cpp nnoremap <F5> :w <bar> :make %:r <bar> :!./%:r <cr>

autocmd FileType python nnoremap <F6> :w <bar> :!python3 % < %:r.dat <cr>
autocmd FileType python nnoremap <F5> :w <bar> :!python3 % <cr>

autocmd FileType java nnoremap <F5> :w <bar> :!javac % <bar> :!java %:r % <cr>

autocmd FileType go nnoremap <F5> :w <bar> :!go run % <cr>

autocmd FileType rust nnoremap <F5> :w <bar> :!cargo run % <cr>
