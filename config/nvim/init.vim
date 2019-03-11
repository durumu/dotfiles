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

" airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'

" ---------------------------------------------------------------------------"
"   generic                                                                  "
" ---------------------------------------------------------------------------"

set fileformats=unix

let mapleader="\<space>"

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

" buffers & windows
set splitbelow        " :sp goes below
set splitright        " :vs goes to right

" flash bracket match on screen
set showmatch
set matchtime=2
let g:matchparen_timeout=20
let g:matchparen_insert_timeout=20

let g:solarized_termtrans=1 " disable this for no transparency

colorscheme solarized

" italicize comments
highlight comment cterm=italic

" ---------------------------------------------------------------------------"
"   leader mappings                                                          "
" ---------------------------------------------------------------------------"

" edit commonly-accessed files
nmap <silent> <leader>ev :vsplit $HOME/.config/nvim/init.vim<cr>
nmap <silent> <leader>ep :vsplit $HOME/.config/nvim/plug.vim<cr>
nmap <silent> <leader>ez :vsplit $HOME/.zshrc<cr>
nmap <silent> <leader>sv :source $HOME/.config/nvim/init.vim<cr>
nmap <silent> <leader>sp :source $HOME/.config/nvim/plug.vim<cr>

" move windows around
nmap <silent> <leader>h :wincmd H<cr>
nmap <silent> <leader>j :wincmd J<cr>
nmap <silent> <leader>k :wincmd K<cr>
nmap <silent> <leader>l :wincmd L<cr>

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
nnoremap <silent> <left>:wincmd h<cr> 
nnoremap <silent> <down>:wincmd j<cr>
nnoremap <silent> <up>:wincmd k<cr>
nnoremap <silent> <right>:wincmd l<cr> 
inoremap <left> <nop>
inoremap <down> <nop>
inoremap <up> <nop>
inoremap <right> <nop>

command! Bd bd
command! BD bd
command! Q q
command! W w
command! X x
command! Cn cn
command! Cp cp

" why is this a command
nnoremap Q <nop>
