"Toggles and switches
filetype plugin indent on
syntax on
set encoding=utf-8
" Set hybrid linenumber mode
set number
set relativenumber
set hidden
set wildmenu
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=2
set tabstop=2
set hlsearch
set showcmd
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set incsearch
set ruler
set cmdheight=2

" Give a statusbar to every window to make sure lightline is active
set laststatus=2

" Make sure there are always 10 lines between the cursor and the end of the screen
set scrolloff=10

"Plugins
call plug#begin('~/.vim/plugins')

Plug 'tpope/vim-commentary'
Plug 'zhou13/vim-easyescape'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'jupyter-vim/jupyter-vim'
Plug 'itchyny/lightline.vim'

call plug#end()

"Appearance
set background=dark
colorscheme solarized

"Keymaps
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 800
nnoremap <Space> <Nop>
cnoremap jk <ESC>
cnoremap kj <ESC>
noremap o o<ESC>
noremap O O<ESC>

let mapleader = ","
let maplocalleader = ","

let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"

nnoremap g- g;

"Window moving
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-x> <C-w>x


" Comment strings
autocmd FileType gnuplot setlocal commentstring=#\ %s
autocmd FileType c setlocal commentstring=//\ %s
