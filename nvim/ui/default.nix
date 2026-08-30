{
  imports = [
    ./lualine.nix
    ./devicons.nix
    ./notify.nix
    ./fzf-lua.nix
  ];

  opts = {
    number = true;
    relativenumber = true;
    linebreak = true;
    breakindent = true;
    cursorline = true;
    scrolloff = 20;
    splitbelow = true;
    splitright = true;
    smoothscroll = true;
    fillchars = {
      eob = " ";
      fold = " ";
    };
    signcolumn = "no";
    foldcolumn = "0";
    statuscolumn = "%{%v:lua.make_statuscolumn()%}";
    cmdheight = 0;
    cmdwinheight = 10;
    showmode = false;
    showcmd = false;
    shortmess = "ltToOCFscS";
    termguicolors = false;
  };

  extraConfigLuaPre = builtins.readFile ./fold.lua;

  extraConfigLua = ''
    		pcall(function() require('vim._core.ui2').enable() end)
    	'';

  autoCmd = [
    {
      event = [ "FileType" "BufWinEnter" ];
      command = "setlocal foldtext=v:lua.make_foldtext()";
    }
    # {
      # event = [ "VimLeave" ];
      # group = "restore_cursor";
      # pattern = "*";
      # desc = "Restore cursor to pipe after exiting neovim";
      # callback.__raw = ''function() os.execute [[ echo -ne "\e[6 q" ]] end'';
    # }
  ];
}
