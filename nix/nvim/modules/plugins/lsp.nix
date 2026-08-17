{ pkgs, ... }:
{
	# LSP via nixvim's native `lsp` module (matches your vim.lsp.enable + lsp/*.lua
	# approach). ported from lsp/lua_ls.lua, lsp/texlab.lua, plugin/21_lsp.lua.
	# servers were installed via Homebrew/Brewfile before; now via extraPackages.
	#
	# VERIFY (biggest unknown in the port): the exact shape of nixvim's native
	# `lsp` module. If `lsp.servers.<name>.config` is wrong, the fallback is to
	# carry lsp/*.lua verbatim via extraFiles + extraConfigLua "vim.lsp.enable{...}".

	lsp = {
		servers = {
			lua_ls = {
				enable = true;
				config = {
					cmd = [ "lua-language-server" ];
					filetypes = [ "lua" ];
					root_markers = [ ".luarc.json" ".luarc.jsonc" ".git" ];
					settings = {
						Lua = {
							runtime.version = "LuaJIT";
							diagnostics.globals = [ "vim" "StatusColumn" "FoldText" ];
							workspace = {
								library.__raw = "vim.api.nvim_get_runtime_file('', true)";
								checkThirdParty = false;
							};
							telemetry.enable = false;
						};
					};
				};
			};

			texlab = {
				enable = true;
				config = {
					cmd = [ "texlab" ];
					filetypes = [ "tex" "plaintex" "bib" ];
					root_markers = [ ".latexmkrc" ".git" ];
					settings = {
						texlab = {
							diagnostics.ignoredPatterns = [ "Command terminated with space" ];
							chktex = { onOpenAndSave = true; onEdit = false; };
							latexFormatter = "latexindent";
						};
					};
				};
			};
		};
	};

	lsp.keymaps = [
		{ mode = "n"; key = "gd"; lspBufAction = "definition";  options.desc = "LSP: [g]oto [d]efinition"; }
		{ mode = "n"; key = "gD"; lspBufAction = "declaration"; options.desc = "LSP: [g]oto [D]eclaration"; }
		{ mode = "n"; key = "<leader>d"; action.__raw = "vim.diagnostic.open_float"; options.desc = "LSP: show [d]iagnostic"; }
	];
}
