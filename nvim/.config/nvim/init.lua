-- Plugin manager: vim.pack (built-in, Neovim 0.12+). No bootstrap needed.
-- Plugins are declared here so they load BEFORE any plugin/ file runs, which
-- lets all downstream config (options, keymaps, setup calls) be eager.
--
-- Manage with:
--   :lua vim.pack.update()         update all plugins (review diff, :write to confirm)
--   :lua vim.pack.del({ 'name' })  remove a plugin
-- Lockfile: nvim-pack-lock.json in the config dir (commit it for reproducibility).
-- See :h vim.pack

vim.pack.add({
	{ src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },
	{ src = 'https://github.com/L3MON4D3/LuaSnip' },                       -- before blink (its snippet source)
	{ src = 'https://github.com/saghen/blink.cmp', version = 'v1.9.1' },   -- v1: v2 needs an untagged main + blink.lib
	{ src = 'https://github.com/lervag/vimtex' },
})
