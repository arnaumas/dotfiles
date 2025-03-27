local set = vim.opt
local map = vim.keymap.set

set.cursorlineopt = 'screenline' -- highlight cursor position
set.ruler = false

-- remap screen motions to text motions
map({ 'n', 'o', 'v' }, 'gj', 'j', { silent = true , buffer = true }) -- move down one text line
map({ 'n', 'o', 'v' }, 'gk', 'k', { silent = true , buffer = true }) -- move up one text line
map({ 'n', 'o', 'v' }, 'g0', '0', { silent = true , buffer = true }) -- go to beginning of text line
map({ 'n', 'o', 'v' }, 'g$', '$', { silent = true , buffer = true }) -- go to end of text line
map('o', 'g_', '_', { silent = true , buffer = true })

-- remap text motions to screen motions
map({ 'n', 'o', 'v' }, 'j', 'gj', { silent = true , buffer = true }) -- move down one screen line
map({ 'n', 'o', 'v' }, 'k', 'gk', { silent = true , buffer = true }) -- move up one screen line
map({ 'n', 'o', 'v' }, '0', 'g0', { silent = true , buffer = true }) -- go to beginning of screen line
map({ 'n', 'o', 'v' }, '$', 'g$', { silent = true , buffer = true }) -- go to end of screen line
map('o', '_', 'g_', { silent = true , buffer = true })

map('n', 'A', '$a', { silent = true , buffer = true }) -- append to end of screen line

vim.opt_local.cmdheight = 1 -- don't hide the cmd line to avoid getting the press Enter prompt when compiling

