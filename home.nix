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
    ./kitty
    ./ghostty
    ./git
    ./vim
    ./claude
    ./pi
  ];
}
