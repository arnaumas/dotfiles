call plug#begin()
"nord colorscheme
Plug 'shaunsingh/nord.nvim' 
Plug 'lervag/vimtex'
call plug#end()

set termguicolors

" override search hits highlighting
augroup SearchMatch
	autocmd!
	autocmd Colorscheme nord highlight Search guibg=#81a1c1
				\| highlight CurSearch guifg=#2e3440 guibg=#Ebcb8b 
				\| highlight IncSearch guifg=#2e3440 guibg=#Ebcb8b 
augroup END

" make vim background transparent
let g:nord_disable_background = v:true

colorscheme nord

"TODO: figure out how to make cursor respect fg and bg colors
