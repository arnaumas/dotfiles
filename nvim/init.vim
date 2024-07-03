" -------- PLUGINS
call plug#begin()
"nord colorscheme
Plug 'shaunsingh/nord.nvim'
 
"lua based snippet manager
Plug 'L3MON4D3/LuaSnip'

" latex functionality
Plug 'lervag/vimtex'
call plug#end()

" -------- MAPPINGS
let mapleader = ","
let localmapleader = ","


" -------- COLORSCHEME
let g:nord_disable_background = v:true
colorscheme nord

" override nord highlights
autocmd ColorScheme nord
			\ highlight Search guibg=#81a1c1 |
			\ highlight IncSearch guifg=#2e3440 guibg=#ebcb8b |
			\ highlight Comment guifg=#b8bec7 |
			\ highlight LineNr guifg=#b8bec7

" -------- VISUAL SETTINGS
set number

autocmd VimLeave * set guicursor=a:ver25

" -------- LUASNIP SETTINGS
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
