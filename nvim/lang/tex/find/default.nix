{ palette, ... }:
{
  files."after/ftplugin/tex.lua".keymaps = [
    {
      mode = "n";
      key = "<leader>ft";
      action.__raw = "_G.tex_toc_fzf";
      options = {
        desc = "[f]ind in [t]oc";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fa";
      action.__raw = "_G.tex_labels_fzf";
      options = {
        desc = "[f]ind in l[a]bels";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fo";
      action.__raw = "_G.tex_todo_fzf";
      options = {
        desc = "[f]ind in t[o]dos";
        silent = true;
      };
    }
  ];

  colors.groups = {
    TexRefEq = { fg = palette.cyan; bold = true; };
    TexRefFig = { fg = palette.magenta; bold = true; };
    TexRefTab = { fg = palette.blue; bold = true; };
    TexRefOther = { fg = palette.green; bold = true; };

    TexTodo = { fg = palette.green; bold = true; };
    TexTodoNote = { fg = palette.blue; bold = true; };
    TexTodoWarn = { fg = palette.magenta; bold = true; };
    TexTodoError = { fg = palette.red; bold = true; };
    TexTodoFatal = { fg = palette.red; bold = true; };
  };

  extraConfigLua = builtins.readFile ./pickers.lua;
}
