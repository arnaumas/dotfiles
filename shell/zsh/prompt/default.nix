{ pkgs, lib, ... }:
{
	programs.zsh.sessionVariables = {
		PURE_PROMPT_SYMBOL = ">";
		PURE_PROMPT_VICMD_SYMBOL = "<";
		PURE_GIT_UP_ARROW = "↑";
		PURE_GIT_DOWN_ARROW = "↓";
	};

	programs.zsh.shellAliases.clear = "unset NEW_LINE_BEFORE_PROMPT && clear";

	programs.zsh.initContent = lib.mkAfter ''
		fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
		${builtins.readFile ./prompt.zsh}
	'';
}
