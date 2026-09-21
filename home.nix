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
    ./wezterm
    ./ghostty
    ./git
    ./vim
    ./claude
    ./pi
  ];
}
