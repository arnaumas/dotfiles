{ lib, ... }:
{
	programs.zsh.autosuggestion = {
		enable = true;
		highlight = "fg=7";
		strategy = [];
	};

	programs.zsh.localVariables = {
		ZSH_AUTOSUGGEST_STRATEGY = [ "unique_completion" ];
		ZSH_AUTOSUGGEST_USE_ASYNC = 1;
	};

	programs.zsh.initContent = lib.mkAfter (builtins.readFile ./autocompletion.zsh);	
}
