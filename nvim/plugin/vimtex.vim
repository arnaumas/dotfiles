let g:vimtex_imaps_leader = "."
let g:vimtex_view_method = 'skim'

"  make editor regain focus after inverse search
function! s:TexFocusVim() abort
	silent execute "!open -a iTerm"
	redraw!
endfunction

augroup vimtex_event_focus
	au!
	au User VimtexEventViewReverse call s:TexFocusVim()
augroup END
