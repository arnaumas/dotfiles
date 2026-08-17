{
	opts = {
		# general
		swapfile = false;
		clipboard = "unnamedplus";

		# ui
		number = true;
		relativenumber = true;
		linebreak = true; # wrap at word boundaries
		breakindent = true; # keep indent on wrapped lines
		cursorline = true;
		scrolloff = 20;
		splitbelow = true;
		splitright = true;
		smoothscroll = true;
    fillchars = { eob = " "; fold = " "; };
    signcolumn = "no";
    foldcolumn = "0";
    statuscolumn = "%{%v:lua.make_statuscolumn()%}";
		cmdheight = 0;
		cmdwinheight = 10;
		showmode = false;
		showcmd = false;
		shortmess = "ltToOCFscS";

		# editing
		expandtab = false;
		shiftwidth = 2;
		tabstop = 2;

		termguicolors = false;
	};

	globals = {
		mapleader = " ";
		maplocalleader = " "; # same as leader, matching the current config
		have_nerd_font = true;
	};

	extraConfigLuaPre = builtins.readFile ./fold.lua;

	autoCmd = [
		{
			event = [ "FileType" "BufWinEnter" ];
			command = "setlocal foldtext=v:lua.make_foldtext()";
		}
	];

	extraConfigLua = ''
		pcall(function() require('vim._core.ui2').enable() end)
	'';
}
