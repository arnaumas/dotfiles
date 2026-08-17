let
	# lua and zsh share the same marker-fold config. FoldText is a global helper
	# (re)defined when the ftplugin sources, matching the original files.
	foldFt = {
		opts = {
			foldmethod = "marker";
			foldmarker = " -->,<--";
			wrap = false;
			sidescrolloff = 12;
			foldtext = "v:lua.FoldText()";
			foldcolumn = "auto";
		};
		extraConfigLua = ''
			function FoldText()
				local line = vim.fn.getline(vim.v.foldstart)
				return line:gsub('^-- ', '')
			end
		'';
	};
in
{
	# ftplugins as typed `files` entries (nixvim's typed equivalent of extraFiles).
	# each generates a real ftplugin file on the runtimepath from typed options.
	# ported from after/ftplugin/{lua,zsh,help}.lua and the vimtex-independent part
	# of after/ftplugin/tex.lua. the tex file is contributed to from here (motions)
	# and from plugins/vimtex.nix (imaps); the two merge into one generated file.
	files = {
		"after/ftplugin/lua.lua" = foldFt;
		"after/ftplugin/zsh.lua" = foldFt;

		"after/ftplugin/help.lua" = {
			keymaps = [
				{ mode = "n"; key = "q"; action = "<cmd>helpclose<cr>"; options = { buffer = true; silent = true; }; }
				{ mode = "n"; key = "<cr>"; action = "<C-]>"; options.buffer = true; }
				{ mode = "n"; key = "<bs>"; action = "<C-t>"; options.buffer = true; }
			];
		};

		# tex, vimtex-INDEPENDENT part: screen-line motions for prose.
		"after/ftplugin/tex.lua" = {
			opts = {
				cursorlineopt = "screenline";
				ruler = false;
			};
			keymaps = [
				# global in the original (no buffer scope) -- kept faithful.
				{ mode = "n"; key = "o"; action = "g$a<cr><esc>"; }
				{ mode = [ "n" "o" "v" ]; key = "j"; action = "gj"; options = { silent = true; buffer = true; }; }
				{ mode = [ "n" "o" "v" ]; key = "k"; action = "gk"; options = { silent = true; buffer = true; }; }
				{ mode = [ "n" "o" "v" ]; key = "0"; action = "g0"; options = { silent = true; buffer = true; }; }
				{ mode = [ "n" "o" "v" ]; key = "$"; action = "g$"; options = { silent = true; buffer = true; }; }
				{ mode = "o"; key = "_"; action = "g_"; options = { silent = true; buffer = true; }; }
			];
		};
	};
}
