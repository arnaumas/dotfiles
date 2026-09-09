{ config, ... }:
{
  home.sessionVariables = {
    LESS = "-FRX --tilde --use-color --color=SyKd -Ps?n?f%f .?m(%T %i of %m) ..?x- Next\\: %x..%t";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
  };
}
