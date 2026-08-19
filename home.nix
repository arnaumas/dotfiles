{ pkgs, ... }:
{
	home = {
		username = "arnau";
		homeDirectory = "/Users/arnau";
		stateVersion = "26.05";
		packages = with pkgs; [
			tmux
			fzf
			fd
			ripgrep
			bat
		];
	};

	programs = {
		home-manager.enable = true;

    nixvim = {
			enable = true;
			imports = [ ./nvim ];
		};
	};

	imports = [
		./borders
		./claude
		./git
		./ghostty
		./karabiner
		./sketchybar
		./skhd
		./sioyek
		./svim
		./tmux
		./vim
		./yabai
		./zsh
	];
}
