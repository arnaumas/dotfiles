{
  lsp.servers.texlab = {
    enable = true;
    config = {
      cmd = [ "texlab" ];
      filetypes = [ "tex" "plaintex" "bib" ];
      root_markers = [ ".latexmkrc" ".git" ];
      settings = {
        texlab = {
          diagnostics.ignoredPatterns = [ "Command terminated with space" ];
          chktex = {
            onOpenAndSave = true;
            onEdit = false;
          };
          latexFormatter = "latexindent";
        };
      };
    };
  };
}
