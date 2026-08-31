{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.tmux.enable {
    extraConfigLuaPre = builtins.readFile ./tmux-nav.lua;
    keymaps = lib.mkAfter [
      {
        mode = [ "n" "t" ];
        key = "<C-h>";
        action = "<cmd>lua tmux_nav('h')<cr>";
        options.desc = "focus/pane left";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-j>";
        action = "<cmd>lua tmux_nav('j')<cr>";
        options.desc = "focus/pane below";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-k>";
        action = "<cmd>lua tmux_nav('k')<cr>";
        options.desc = "focus/pane above";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-l>";
        action = "<cmd>lua tmux_nav('l')<cr>";
        options.desc = "focus/pane right";
      }
    ];
  };

  programs.tmux.extraConfig = lib.mkIf config.programs.nixvim.enable (lib.mkAfter ''
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?|fzf)(diff)?$'"
    bind -n C-h if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
    bind -n C-j if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
    bind -n C-k if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
    bind -n C-l if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
  '');
}
