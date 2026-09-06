{
  imports = [ ./highlights.nix ];

  extraFiles."after/queries/latex/highlights.scm".source = ./highlights.scm;

  extraConfigLua = builtins.readFile ./queries.lua;
}
