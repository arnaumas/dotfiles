{ pkgs, ... }:
{
	home = {
		username = "arnau";
		homeDirectory = "/Users/arnau";
		stateVersion = "26.05";
		# fzf, ripgrep, bat are installed by their programs.* modules in ./zsh
		packages = with pkgs; [
			tmux
			fd
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
		./claude
		./git
		./ghostty
		./sioyek
		./svim
		./tmux
		./vim
		./zsh
	];
}
