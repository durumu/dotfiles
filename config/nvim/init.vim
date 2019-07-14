" ---------------------------------------------------------------------------"
"   .initvim                                                                 "
" ---------------------------------------------------------------------------"

" ---------------------------------------------------------------------------"
"   plugins                                                                  "
" ---------------------------------------------------------------------------"

" install plugin manager & all plugins
source $HOME/.config/nvim/plug.vim

" ---------------------------------------------------------------------------"
"   plugin config                                                            "
" ---------------------------------------------------------------------------"

" vim-tex
let g:tex_flavor="latex" " fix default behavior for .tex
let g:vimtex_view_method="zathura"

" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:ultisnips_python_style="google" " for honza/vim-snippets

" ---------------------------------------------------------------------------"
"   airline                                                                  "
" ---------------------------------------------------------------------------"

" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" Use powerline fonts
let g:airline_powerline_fonts = 1

" Solarize all the things
let g:airline_theme='solarized'

" ---------------------------------------------------------------------------"
"   generic                                                                  "
" ---------------------------------------------------------------------------"

set fileformats=unix

let mapleader="\<space>"
let maplocalleader="\<space>"

" search isn't case sensitive
set ignorecase
set smartcase

" ---------------------------------------------------------------------------"
"   indent                                                                   "
" ---------------------------------------------------------------------------"

set shiftwidth=0 " make < and > do the same thing as tab
set softtabstop=-1

" 1 tab = 2 spaces
set expandtab
set tabstop=2

" except for Python
autocmd FileType python :set tabstop=4
" also java
autocmd FileType java :set noexpandtab tabstop=4

" ---------------------------------------------------------------------------"
"   aesthetics                                                               "
" ---------------------------------------------------------------------------"

" buffer area
set number
set scrolloff=7
set wrap
set linebreak         " break in middle of words
set textwidth=79      " break to 79 chars wide
set noerrorbells
set noshowmode

" buffers & windows
set splitbelow        " :sp goes below
set splitright        " :vs goes to right

" flash bracket match on screen
set showmatch
set matchtime=2
let g:matchparen_timeout=20
let g:matchparen_insert_timeout=20

" let g:solarized_termtrans=1 " disable this for no transparency
" colorscheme solarized
set bg=dark

" replace tildes with whitespace
set fcs=eob:\ 

" italicize comments
highlight comment cterm=italic

" partial search
set inccommand=nosplit

" ---------------------------------------------------------------------------"
"   leader mappings                                                          "
" ---------------------------------------------------------------------------"

" edit commonly-accessed files
nmap <silent> <leader>ev :split $HOME/.config/nvim/init.vim<cr>
nmap <silent> <leader>ep :split $HOME/.config/nvim/plug.vim<cr>
nmap <silent> <leader>ez :split $HOME/.zshrc<cr>
nmap <silent> <leader>sv :source $HOME/.config/nvim/init.vim<cr>

" clear highlighting
nnoremap <silent> <leader><space> :nohlsearch<cr>

" ---------------------------------------------------------------------------"
"   other mappings                                                           "
" ---------------------------------------------------------------------------"

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Y = yank to end of line.
nnoremap Y y$

" move by displayed lines
nnoremap j gj
nnoremap k gk

" move focus with arrow keys
nnoremap <silent> <left> <C-w>h
nnoremap <silent> <down> <C-w>j
nnoremap <silent> <up> <C-w>k
nnoremap <silent> <right> <C-w>l

" shift-arrow keys move windows
nnoremap <silent> <S-left> <C-w>H
nnoremap <silent> <S-down> <C-w>J
nnoremap <silent> <S-up> <C-w>K
nnoremap <silent> <S-right> <C-w>L

inoremap <left> <nop>
inoremap <down> <nop>
inoremap <up> <nop>
inoremap <right> <nop>

" fat fingers
command! Bd bd
command! BD bd
command! Q q
command! W w
command! Cn cn
command! Cp cp

" why is this a command
nnoremap Q <nop>

nnoremap <silent> <enter> <C-]>
