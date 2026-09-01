{ ... }:
{
  xdg.enable = true;

  programs = {
    home-manager.enable = true;

    nixvim = {
      enable = true;
      imports = [ ./nvim ];
    };
  };

  imports = [
    ./shell
    ./claude
    ./pi
    ./git
    ./ghostty
    ./svim
    ./vim
  ];
}
