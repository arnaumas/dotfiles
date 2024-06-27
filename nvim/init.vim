call plug#begin()
" nord colorscheme
Plug 'shaunsingh/nord.nvim'

" lua based snippet manager
Plug 'L3MON4D3/LuaSnip'

" latex functionality
Plug 'lervag/vimtex'
call plug#end()

let g:nord_disable_background = v:true
colorscheme nord

autocmd ColorScheme nord
			\ highlight Search guibg=#81a1c1 |
			\ highlight CurSearch guifg=#2e3440 guibg=#ebcb8b |
			\ highlight IncSearch guifg=#2e3440 guibg=#ebcb8b |
			\ highlight Comment guifg=#b8bec7 |
			\ highlight LineNr guifg=#b8bec7 

set number
