local map = vim.keymap.set

map('n', 'o', 'o<esc>', { desc = '[o]pen line' })
map('n', 'O', 'O<esc>', { desc = '[o]pen line above' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'move focus to the window to the left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'move focus to the window to the right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'move focus to the window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'move focus to the window above' })

map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'clear highlights' })

map('n', '<leader>pv', vim.cmd.Ex, { desc = '[p]roject [v]iew'})

-- luasnip expand snippet keymaps
local luasnip = require 'luasnip'

map({'i','s'}, '<C-l>', function()
  if luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

map({'i','s'}, '<C-h>', function()
  if luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

luasnip.config.setup({
  store_selection_keys = '<C-l>',
  update_events = 'TextChanged, TextChangedI'
})
