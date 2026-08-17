{ pkgs, ... }:
{
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
