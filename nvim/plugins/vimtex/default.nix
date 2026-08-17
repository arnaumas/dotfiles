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
			syntax_conceal = { math_symbols = 0; };
			imaps_disabled = [ "jj" "jJ" "jk" "jK" "jh" "jH" "jl" "jL" ];
			log_ignore = [ "Compilation completed" "Compilation failed" "Compiler start" "Compiler stopped" ];
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

	extraFiles."after/syntax/tex.vim".source = ./tex.vim;

	extraConfigLua = builtins.readFile ./notify-compilation.lua;
}
