{
  opts = {
    expandtab = false;
    shiftwidth = 2;
    tabstop = 2;
  };

  keymaps = [
    {
      mode = "n";
      key = "o";
      action = ''op<Esc><Cmd>silent!undojoin<CR>"_x<esc>'';
      options.desc = "[o]pen line";
    }
    {
      mode = "n";
      key = "O";
      action = ''Op<Esc><Cmd>silent!undojoin<CR>"_x<esc>'';
      options.desc = "[o]pen line above";
    }
    {
      mode = [ "n" "x" ];
      key = "K";
      action = "i<cr><esc>";
    }
    {
      mode = [ "n" "x" ];
      key = "u";
      action = "<CMD>silent undo<CR>";
    }
    {
      mode = [ "n" "v" ];
      key = "u";
      action = "<CMD>silent undo<CR>";
    }
    # system clipboard yanking and pasting
    {
      mode = [ "n" "x" ];
      key = "gy";
      action = ''"+y'';
      options.desc = "yank into system clipboard";
    }
    {
      mode = [ "n" "x" ];
      key = "gY";
      action = ''"+Y'';
      options.desc = "yank until EOL into system clipboard";
    }
    {
      mode = [ "n" "x" ];
      key = "gp";
      action = ''"+p'';
      options.desc = "paste from system clipboard";
    }
    {
      mode = [ "n" "x" ];
      key = "gP";
      action = ''"+P'';
      options.desc = "paste above from system clipboard";
    }
  ];
  
  plugins = {
    mini-ai.enable = true;
    mini-pairs.enable = true;
    mini-surround = {
      enable = true;
      settings.silent = true;
    };
  };
}
