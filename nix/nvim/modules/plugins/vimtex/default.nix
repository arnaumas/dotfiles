{
	plugins.vimtex = {
		enable = true;
		settings = {
			imaps_leader = ".";
			view_method = "sioyek";
			view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek";
			quickfix_open_on_warning = 0;
			fold_enabled = 1;
			indent_on_ampersands = 1;
			indent_tikz_commands = 0;
			# keep \mathbb{R} etc. as command + arg (not one concealed symbol).
			syntax_conceal = { math_symbols = 0; };
			imaps_disabled = [ "jj" "jJ" "jk" "jK" "jh" "jH" "jl" "jL" ];
		};
	};

	files."after/ftplugin/tex.lua".extraConfigLua = ''
		vim.cmd [[
		call vimtex#imaps#add_map({ 'lhs' : ':', 'rhs' : '\colon', 'wrapper' : 'vimtex#imaps#wrap_math'})
		call vimtex#imaps#add_map({ 'lhs' :	 '=', 'rhs' : '\leq', 'leader' : '<', 'wrapper' : 'vimtex#imaps#wrap_math'})
		call vimtex#imaps#add_map({ 'lhs' : '=', 'rhs' : '\geq', 'leader' : '>', 'wrapper' : 'vimtex#imaps#wrap_math'})
		call vimtex#imaps#add_map({ 'lhs' : 'R', 'rhs' : '\R', 'wrapper' : 'vimtex#imaps#wrap_math'})
		call vimtex#imaps#add_map({ 'lhs' : 'o', 'rhs' : '\in', 'wrapper' : 'vimtex#imaps#wrap_math'})
		]]
	'';

	# pipe-split syntax stays a real .vim file (no typed equivalent).
	extraFiles."after/syntax/tex.vim".source = ./tex.vim;
}
