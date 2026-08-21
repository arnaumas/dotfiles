{ pkgs, ... }:
{
	home = {
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
