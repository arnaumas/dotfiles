{
  imports = [
    ./treesitter.nix
    ./snippets.nix
    ./mini.nix
    ./blink.nix
    ./fold.nix
  ];

  opts = {
    expandtab = false;
    shiftwidth = 2;
    tabstop = 2;
    autoindent = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "o";
      action = "o<esc>";
      options.desc = "[o]pen line";
    }
    {
      mode = "n";
      key = "O";
      action = "O<esc>";
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

  autoGroups.highlight-yank = {
    clear = true;
  };

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      group = "highlight-yank";
      desc = "Highlight when yanking (copying) text";
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];
}
