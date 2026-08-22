{ lib, ... }:
{
	programs.zsh = {
		syntaxHighlighting = {
			enable = true;
			highlighters = [ "main" "brackets" ];
			styles = {
				command = "fg=4";
				builtin = "fg=4";
				function = "fg=4";
				alias = "fg=4";
				precommand = "fg=4";
				single-quoted-argument = "fg=2";
				double-quoted-argument = "fg=2";
				dollar-quoted-argument = "fg=2";
				comment = "fg=3";
				path = "underline";
				globbing = "fg=6";
				unknown-token = "none";
				single-hyphen-option = "none";
				double-hyphen-option = "none";
				commandseparator = "none";
				redirection = "none";
				reserved-word = "none";
				default = "none";
				cursor-matchingbracket = "fg=2,underline";
				bracket-level-1 = "fg=7";
				bracket-level-2 = "fg=7";
				bracket-level-3 = "fg=7";
				bracket-level-4 = "fg=7";
				bracket-error = "fg=7";
			};
		};

		initContent = lib.mkAfter ''
			autoload -U colors && colors
			zle_highlight=('paste:none')
		'';
	};
}
