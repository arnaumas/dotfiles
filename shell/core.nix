{ config, ... }:
{
  home = {
    file.".editrc".source = ./.editrc;

    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANWIDTH = "999";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
      CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
      LS_COLORS = "rs=0:no=0:fi=0:di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";
    };

    shellAliases = {
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -Ivr";
      python = "python3";
      vim = "nvim";
      L = "tmux capture-pane -pS -32768 | less -+F -+X";
      ll = "ls -ohAF --color=always | sed '1d;/.DS_Store/d;s/^.\\{11\\}[[:space:]]*[[:digit:]]*[[:space:]]//g'";
    };
  };

  programs.zsh.envExtra = ''
    		export GNUPGHOME="${config.xdg.configHome}/gnupg"
    	'';
}
