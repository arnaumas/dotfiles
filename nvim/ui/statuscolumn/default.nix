{ lib, ... } : {
  opts = {
    signcolumn = "no";
    statuscolumn = "%{%v:lua.make_statuscolumn()%}";
  };
  
  extraConfigLuaPre = lib.concatMapStringsSep "\n" builtins.readFile [ ./cellwidths.lua ./statuscolumn.lua ];
}
