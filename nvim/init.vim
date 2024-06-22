call plug#begin()
"nord colorscheme
Plug 'shaunsingh/nord.nvim'
Plug 'lervag/vimtex'
call plug#end()

set termguicolors

let g:nord_disable_background = v:true
colorscheme nord

highlight Search guibg=#81a1c1
highlight CurSearch guifg=#2e3440 guibg=#Ebcb8b 
highlight IncSearch guifg=#2e3440 guibg=#Ebcb8b 

"highlight Cursor guibg=red guifg=#f9f9fa gui=NONE
"highlight lCursor guibg=red guifg=#f9f9fa gui=NONE

"set guicursor=n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr-o:hor20-Cursor/lCursor
