{
  imports = [
    ./statusline.nix
    ./devicons.nix
    ./notify.nix
  ];

  opts = {
    number = true;
    relativenumber = true;
    numberwidth = 1;
    linebreak = true;
    breakindent = true;
    cursorline = true;
    scrolloff = 20;
    splitbelow = true;
    splitright = true;
    smoothscroll = true;
    fillchars = {
      eob = " ";
    };
    signcolumn = "no";
    statuscolumn = "%{%v:lua.make_statuscolumn()%}";
    cmdheight = 0;
    cmdwinheight = 10;
    showmode = false;
    showcmd = false;
    shortmess = "ltToOCFscS";
    termguicolors = false;
  };

  extraConfigLuaPre = builtins.readFile ./statuscolumn.lua;

  extraConfigLua = ''
    		pcall(function() require('vim._core.ui2').enable() end)
    	'';
}
