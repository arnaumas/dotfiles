-- LSP via Neovim 0.11 built-ins (vim.lsp.config / vim.lsp.enable).
-- No nvim-lspconfig, no mason. Binaries installed with Homebrew.
-- Completion capabilities are injected globally by blink.cmp's plugin file
-- (vim.lsp.config('*', {...})), so we don't set capabilities per-server here.

-- list of servers to be installed. 
-- they are manually installed with homebrew, and should be listed in Brewfile
local servers = {
	lua_ls = {
		cmd          = { 'lua-language-server' },
		filetypes    = { 'lua' },
		root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
		settings = {
			Lua = {
				runtime     = { version = 'LuaJIT' },
				diagnostics = { globals = { 'vim', 'MiniDeps', 'MiniPick', 'MiniFiles', 'MiniExtra', 'FoldText' } },
				workspace   = {
					library         = vim.api.nvim_get_runtime_file('', true), -- know the vim.* API
					checkThirdParty = false,
				},
				telemetry   = { enable = false },
			},
		},
	},

	texlab = {
		cmd          = { 'texlab' },
		filetypes    = { 'tex', 'plaintex', 'bib' },
		root_markers = { '.latexmkrc', '.git' },
		-- texlab works well with zero settings; build/forward-search can be added later.
	},
}
-- <--

-- register + enable every server in the list. -->
for name, config in pairs(servers) do
	vim.lsp.config(name, config)
end
vim.lsp.enable(vim.tbl_keys(servers))
-- <--

-- Buffer-local keymaps on attach. -->
-- NOTE: 0.11 already provides defaults on attach: K hover, grn rename,
--       gra code action, grr references, gri implementation, gO doc symbols.
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
