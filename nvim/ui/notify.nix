{
  plugins.mini = {
    modules.notify = {
      content.format.__raw = "_M.notify.format";
      window = {
        config = {
          anchor = "NE";
          border = "none";
        };
        winblend = 0;
      };
      lsp_progress.enable = true;
    };
    luaConfig.pre = builtins.readFile ./notify-defs.lua;
    luaConfig.post = builtins.readFile ./notify-wire.lua;
  };

  userCommands.Notifications = {
    command.__raw = ''
      function()
        _M.notify.in_history = true
        require('mini.notify').show_history()
        _M.notify.in_history = false
      end
    '';
    desc = "mini.notify history";
  };
}
