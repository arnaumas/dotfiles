vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', 'o', 'o<esc>', { desc = '[o]pen line' })
map('n', 'O', 'O<esc>', { desc = '[o]pen line above' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'move focus to the window to the left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'move focus to the window to the right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'move focus to the window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'move focus to the window above' })

map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'clear highlights' })
