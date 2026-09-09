{ lib, config, ... }:
{
  programs.zsh = {
    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 10000000;
      save = 10000000;
      share = false;
      extended = false;
      ignoreDups = false;
      ignoreAllDups = false;
      ignoreSpace = false;
      expireDuplicatesFirst = false;
    };

    initContent = lib.mkAfter ''
      			setopt inc_append_history

      			autoload -Uz up-line-or-beginning-search
      			autoload -Uz down-line-or-beginning-search
      			zle -N up-line-or-beginning-search
      			zle -N down-line-or-beginning-search
      			bindkey -M viins "^[[A" up-line-or-beginning-search
      			bindkey -M viins "^[[B" down-line-or-beginning-search
      		'';
  };
}
