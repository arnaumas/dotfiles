let g:vimtex_imaps_leader = "."
let g:vimtex_view_method = "zathura"
let g:vimtex_fold_enabled = 1
let g:tex_flavor = "latex"
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_open_on_warning = 0

" Replace math commands by readable symbols
set conceallevel=1
let g:tex_conceal='abdmgs'

" Automatically wrap lines at 90 characters
set wrap linebreak

" Always keep cursor within 15 lines from the top and bottom of the screen
set scrolloff=15

set wrap lbr
noremap <buffer> <silent> K k
noremap <buffer> <silent> J j
noremap <buffer> <silent> g0 0 
noremap <buffer> <silent> g$ $ 
onoremap <buffer> <silent> K k
onoremap <buffer> <silent> J j
onoremap <buffer> <silent> g0 0 
onoremap <buffer> <silent> g$ $ 
onoremap <buffer> <silent> g_ _ 

noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$
noremap <buffer> <silent> A $a
onoremap <buffer> <silent> k gk
onoremap <buffer> <silent> j gj
onoremap <buffer> <silent> 0 g0
onoremap <buffer> <silent> $ g$
onoremap <buffer> <silent> _ g_
onoremap <buffer> <silent> A $a

call vimtex#imaps#add_map({ 'lhs' : ':', 'rhs' : '\colon', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' :  '=', 'rhs' : '\leq', 'leader' : '<', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : '=', 'rhs' : '\geq', 'leader' : '>', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : '->', 'rhs' : '\to', 'leader' : '', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : '=>', 'rhs' : '\implies', 'leader' : '', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : 'R', 'rhs' : '\R', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : 'o', 'rhs' : '\in', 'wrapper' : 'vimtex#imaps#wrap_math'})

let g:vimtex_imaps_disabled = ['jj', 'jJ', 'jk', 'jK', 'jh', 'jH', 'jl', 'jL']


