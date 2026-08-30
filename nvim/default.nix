{
  imports = [
    ./editing
    ./ui
    ./files
    ./git
    ./lsp
    ./lang
    ./colors
  ];

  opts = {
    swapfile = false;
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<esc>";
      action = "<CMD>nohlsearch<CR>";
      options.desc = "clear highlights";
    }
    {
      mode = [ "n" "x" ];
      key = "<leader>r";
      action = "q";
      options.desc = "[r]ecord macro";
    }
    {
      mode = [ "n" "x" ];
      key = "q";
      action = "<nop>";
    }
    {
      mode = "n";
      key = ":";
      action = "q:i";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<CMD>silent update<CR>";
      options.desc = "[w]rite file";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<CMD>if winnr('$')>1 |  close | else | quitall | endif<CR>";
      options.desc = "close window";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>quit!<cr>";
      options.desc = "force [q]uit file";
    }
  ];
}
