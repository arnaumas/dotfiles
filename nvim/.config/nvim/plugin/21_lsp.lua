-- LSP wiring. Server configs live in lsp/<name>.lua on the runtimepath and are
-- auto-discovered by vim.lsp.enable(). Servers are installed via Homebrew
-- (listed in the Brewfile). Completion capabilities are injected globally by
-- blink.cmp's plugin file, so no per-server capabilities needed here.

-- enable language servers (must match the filenames in lsp/). -->
vim.lsp.enable({ 'lua_ls', 'texlab' })
-- <--

-- buffer-local keymaps shared by every server servers -->
vim.api.nvim_create_autocmd('LspAttach', {
	group    = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
	callback = function(ev)
		local map = function(keys, fn, desc)
			vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = 'LSP: ' .. desc })
		end
		map('gd', vim.lsp.buf.definition,           '[g]oto [d]efinition')
		map('gD', vim.lsp.buf.declaration,          '[g]oto [D]eclaration')
		map('<Leader>d', vim.diagnostic.open_float, 'show [d]iagnostic')
	end,
})
-- <--
