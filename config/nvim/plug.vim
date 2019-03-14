" ----------------------------------------------------------------------------
"   plug
" ----------------------------------------------------------------------------

" install plug if we don't already have it
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.config/nvim/init.vim
endif

call plug#begin('~/.local/share/nvim/plugins')

" ----------------------------------------------------------------------------
"   aesthetics
" ----------------------------------------------------------------------------

" status line
Plug 'itchyny/lightline.vim'

" solarized colorscheme (:colo solarized)
Plug 'altercation/vim-colors-solarized'

" ----------------------------------------------------------------------------
"   file system
" ----------------------------------------------------------------------------

" navigate files in a sidebar
Plug 'scrooloose/nerdtree'

" open files with ctrl-p
Plug 'ctrlpvim/ctrlp.vim'

" :Mkdir, :Move, :Rename and others
Plug 'tpope/vim-eunuch'

" ----------------------------------------------------------------------------
"   movements & objects
" ----------------------------------------------------------------------------

" gS to split, gJ to join
Plug 'AndrewRadev/splitjoin.vim'

" gc to comment, gcu to uncomment
Plug 'tpope/vim-commentary'

" [, ] do much more
Plug 'tpope/vim-unimpaired'

" i object - indent level
Plug 'michaeljsmith/vim-indent-object'

" a object - argument
Plug 'vim-scripts/argtextobj.vim'

" s object - surrounding delimiters. plus ys to switch
Plug 'tpope/vim-surround'

" ----------------------------------------------------------------------------
"   specialized plugins
" ----------------------------------------------------------------------------

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

Plug 'lervag/vimtex', { 'for' : 'tex' }

Plug 'octol/vim-cpp-enhanced-highlight', { 'for' : 'cpp' }

Plug 'dansomething/vim-eclim', { 'for' : ['cpp', 'c', 'java', 'python'] }

" ----------------------------------------------------------------------------
"   shortcuts & linting
" ----------------------------------------------------------------------------

" tab - complete snippets
Plug 'SirVer/ultisnips'

" snippet repo for ultisnips
Plug 'honza/vim-snippets'

" asynchronous lint engine
Plug 'w0rp/ale'

" ----------------------------------------------------------------------------
"   miscellaneous
" ----------------------------------------------------------------------------

" take notes and keep todo lists in vim
Plug 'vimwiki/vimwiki'

" only show cursorline in the current window
Plug 'vim-scripts/CursorLineCurrentWindow'

" make . work correctly
Plug 'tpope/vim-repeat'

" ----------------------------------------------------------------------------

filetype plugin indent on                   " required!
call plug#end()
