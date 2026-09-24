{ ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
