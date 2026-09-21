{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.emptyDirectory else pkgs.wezterm;
    enableZshIntegration = false;
    settings.window_close_confirmation = "NeverPrompt";
  };
}
