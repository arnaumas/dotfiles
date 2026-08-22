{ pkgs, ... }:
{
	xdg.enable = true;

	home = {
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
		./shell
		./claude
		./git
		./ghostty
		./sioyek
		./svim
		./vim
	];
}
