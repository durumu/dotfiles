" }}}-------------------------------------------------------------------------
"   init.vim                                                              {{{
" ----------------------------------------------------------------------------

" }}}-------------------------------------------------------------------------
"   Plugin                                                                {{{
" ----------------------------------------------------------------------------

" Installing the Plug plugin manager, and all the plugins are included in this
" other file.
source $HOME/.config/nvim/plug.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set fileformats=unix

set mouse=c         " mouse only used in command-line mode
set hidden          " don't close files when opening new ones

set cmdheight=2     " command line has height of 2 

"" no bell 
set noerrorbells
" set novisualbell
" set t_vb=
" set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TeX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tex_flavor="latex" " fix default behavior for .tex

let g:vimtex_view_method="zathura"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set smartcase " search is case sensitive if there are uppercase letters
" set nomagic " ., *, etc work as expected -- use \m to do a 'regex'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=0 " make < and > do the same thing as tab
set softtabstop=-1

" 1 tab = 2 spaces
set expandtab
set tabstop=2

" except for Python
autocmd FileType python :set tabstop=4
" also java
autocmd FileType java :set noexpandtab tabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set scrolloff=7

" Match brackets
set showmatch
set matchtime=2
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
nnoremap <silent>   <Esc> :set nopaste <cr> :nohlsearch <cr>

" arrows!
nnoremap <silent>  <Left>:wincmd h <cr> 
nnoremap <silent>  <Down>:wincmd j <cr>
nnoremap <silent>    <Up>:wincmd k <cr>
nnoremap <silent> <Right>:wincmd l <cr> 
