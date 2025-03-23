local map = vim.keymap.set

map('n', 'q', '<cmd>helpclose<cr>', { buffer = 0, silent = true }) -- make q exit help
map('n', '<cr>', '<C-]>', { buffer = 0 }) -- jump to the section under the cursor
map('n', '<bs>', '<C-t>', { buffer = 0 }) -- return from last jump
