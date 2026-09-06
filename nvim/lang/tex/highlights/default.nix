{
  extraFiles."after/queries/latex/highlights.scm".source = ./highlights.scm;

  colors.extraLua = builtins.readFile ./highlights.lua;

  extraConfigLua = builtins.readFile ./queries.lua;
}
