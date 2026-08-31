{
  opts = {
    foldcolumn = "0";
    fillchars.fold = " ";
  };

  extraConfigLuaPre = builtins.readFile ./fold.lua;

  autoCmd = [
    {
      event = [ "FileType" "BufWinEnter" ];
      command = "setlocal foldtext=v:lua.make_foldtext()";
    }
  ];
}
