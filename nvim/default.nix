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
      action = "<cmd>quitall<CR>";
      options.desc = "[q]uit file";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>quit!<cr>";
      options.desc = "force [q]uit file";
    }
    {
      mode = "n";
      key = "<leader>bn";
      action.__raw = "vim.cmd.bn";
      options.desc = "[b]uffer [n]ext";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action.__raw = "vim.cmd.bp";
      options.desc = "[b]uffer [p]revious";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = "vim.cmd.bd";
      options.desc = "[b]uffer [d]elete";
    }
    {
      mode = "n";
      key = "<leader>bs";
      action.__raw = "vim.cmd.sp";
      options.desc = "[b]uffer [s]plit";
    }
  ];
}
