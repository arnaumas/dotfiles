{
  lsp.keymaps = [
    {
      mode = "n";
      key = "gd";
      lspBufAction = "definition";
      options.desc = "LSP: [g]oto [d]efinition";
    }
    {
      mode = "n";
      key = "gD";
      lspBufAction = "declaration";
      options.desc = "LSP: [g]oto [D]eclaration";
    }
    {
      mode = "n";
      key = "<leader>d";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "LSP: show [d]iagnostic";
    }
  ];

  colors.extraLua = builtins.readFile ./highlights.lua;
}
