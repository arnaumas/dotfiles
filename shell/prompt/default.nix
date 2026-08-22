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
		autoload -Uz async && async
		source ${./prompt.zsh}

		new-line() {
			if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
				NEW_LINE_BEFORE_PROMPT=1
			elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
				echo ""
			fi
		}
		autoload -Uz add-zsh-hook
		add-zsh-hook precmd new-line
	'';
}
