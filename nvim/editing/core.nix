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
  ];
}
