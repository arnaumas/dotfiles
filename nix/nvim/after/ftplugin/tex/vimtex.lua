-- tex ftplugin, VIMTEX-specific part (from after/ftplugin/tex.lua).
-- extra insert-mode math maps registered through vimtex's imaps API.
-- (global g:vimtex_* vars, incl. imaps_disabled, live in plugins/vimtex.nix settings.)
vim.cmd [[
call vimtex#imaps#add_map({ 'lhs' : ':', 'rhs' : '\colon', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' :  '=', 'rhs' : '\leq', 'leader' : '<', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : '=', 'rhs' : '\geq', 'leader' : '>', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : 'R', 'rhs' : '\R', 'wrapper' : 'vimtex#imaps#wrap_math'})
call vimtex#imaps#add_map({ 'lhs' : 'o', 'rhs' : '\in', 'wrapper' : 'vimtex#imaps#wrap_math'})
]]
