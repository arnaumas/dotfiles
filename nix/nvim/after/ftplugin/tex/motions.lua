-- tex ftplugin, vimtex-INDEPENDENT part (from after/ftplugin/tex.lua).
-- screen-line motions for prose writing; sourced for tex buffers alongside
-- any other after/ftplugin/tex/*.lua contributions.
local set = vim.opt
local map = vim.keymap.set

set.cursorlineopt = 'screenline' -- highlight cursor position on the screen line
set.ruler = false

map('n', 'o', 'g$a<cr><esc>')

-- swap text motions for screen motions (LaTeX prose soft-wraps)
map({ 'n', 'o', 'v' }, 'j', 'gj', { silent = true, buffer = true }) -- down one screen line
map({ 'n', 'o', 'v' }, 'k', 'gk', { silent = true, buffer = true }) -- up one screen line
map({ 'n', 'o', 'v' }, '0', 'g0', { silent = true, buffer = true }) -- start of screen line
map({ 'n', 'o', 'v' }, '$', 'g$', { silent = true, buffer = true }) -- end of screen line
map('o', '_', 'g_', { silent = true, buffer = true })
