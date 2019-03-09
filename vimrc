" Julia's .vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
filetype off

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vundle init begin
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin("~/.vundle-plugins/")
Plugin 'VundleVim/Vundle.vim'

" Aesthetics 
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'octol/vim-cpp-enhanced-highlight'

" Movements
Plugin 'tpope/vim-commentary' " gc movement
Plugin 'tpope/vim-surround'   " ys, cs, ds

" Formatting
Plugin 'SirVer/ultisnips'     " tab-complete snippets
Plugin 'honza/vim-snippets'   " snippet repo for UltiSnips
Plugin 'google/vim-maktaba'   " prereq for codefmt
Plugin 'google/vim-codefmt'   " prereq for codefmt
Plugin 'google/vim-glaive'   " prereq for codefmt

" Functionality
Plugin 'ludovicchabant/vim-gutentags' " tag manager

" Miscellaneous
Plugin 'lervag/vimtex'        " TeX support

" Vundle init complete
call vundle#end()
filetype plugin indent on

" Glaive init
call glaive#Install()
Glaive codefmt plugin[mappings]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" doesn't work yet.
let g:gutentags_ctags_tagfile=".git/tags"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TeX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tex_flavor="latex" " fix default behavior for .tex

let g:vimtex_view_method="zathura"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set smartcase " search is case sensitive if there are uppercase letters
set hlsearch
set incsearch
" set nomagic " ., *, etc work as expected -- use \m to do a 'regex'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent
set smarttab
set wrap

" 1 tab = 2 spaces
set expandtab
set shiftwidth=2 
set softtabstop=2

" except for Python
autocmd FileType python :set shiftwidth=4 softtabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" set t_Co=256                " if screen not transparent
" let g:solarized_termcolors=256
" set background=light
set background=dark
let g:solarized_termtrans=1 " disable this for no transparency
colorscheme solarized
" italic comments!
highlight comment cterm=italic

" Airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Trigger configuration. 
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsListSnippets="<s-space>"
let g:UltiSnipsJumpForwardTrigger="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Set docstring style to Google 
let g:ultisnips_python_style="google"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
