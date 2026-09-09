{ config, ... }:
{
  home.sessionVariables = {
    LESS = "-FRX -g --tilde --use-color --color=Syd --color=P- --color=E- -Ps?n?f%f .?m(%T %i of %m) ..?x- Next\\: %x..%t";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
  };
}
