{
  plugins.mini-git = { };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Git commit<cr>";
      options.desc = "[g]it [c]ommit";
    }
    {
      mode = "n";
      key = "<leader>ga";
      action = "<cmd>Git diff --cached<cr>";
      options.desc = "[g]it [a]dd";
    }
  ];
}
