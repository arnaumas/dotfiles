{ lib, ... }:
{
	programs.zsh = {
		autosuggestion = {
			enable = true;
			highlight = "fg=7";
			strategy = [];
		};

		completionInit = ''
			_comp_options+=(globdots)
			autoload -U compinit
			compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
			zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
		'';

		localVariables = {
			ZSH_AUTOSUGGEST_STRATEGY = [ "unique_completion" ];
			ZSH_AUTOSUGGEST_USE_ASYNC = 1;
		};

		initContent = lib.mkAfter (builtins.readFile ./completion.zsh);	
	};
}
