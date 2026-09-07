{
  imports = [
    ./palette.nix
    ./colorscheme.nix
    ./highlights.nix
  ];

  opts = {
    swapfile = false;
    report = 9999;
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
      mode = [
        "n"
        "x"
      ];
      key = "<leader>r";
      action = "q";
      options.desc = "[r]ecord macro";
    }
    {
      mode = [
        "n"
        "x"
      ];
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

    # splits
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "focus window left";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "focus window below";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "focus window above";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "focus window right";
    }
    {
      mode = "n";
      key = "<C-w>v";
      action = "<C-w>v<cmd>silent! buffer next<CR>";
      options.desc = "split vertically";
    }
    {
      mode = "n";
      key = "<C-w>s";
      action = "<C-w>s<cmd>silent! buffer next<CR>";
      options.desc = "split horizontally";
    }

    # buffers
    {
      mode = "n";
      key = "<leader>bn";
      action = "<CMD>buffer next<CR>";
      options.desc = "open next buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<CMD>buffer previous<CR>";
      options.desc = "open previous buffer";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<CMD>buffer delete<CR>";
      options.desc = "delete buffer";
    }
  ];
}
