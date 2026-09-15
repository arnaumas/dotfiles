{ config, lib, ... }:
{
  home.sessionVariables = {
    PYTHONSTARTUP = "${config.xdg.configHome}/python/startup.py";
    PYTHON_BASIC_REPL = "1";
  };

  xdg.configFile."python/startup.py".source = ./startup.py;

  xdg.configFile."readline/inputrc".text = lib.mkAfter ''
    $if python
    set show-mode-in-prompt on
    set vi-ins-mode-string "\1\e[6 q\e[0;34m\2py >\1\e[0m\2"
    set vi-cmd-mode-string "\1\e[2 q\e[0;34m\2py <\1\e[0m\2"
    $endif
  '';
}
