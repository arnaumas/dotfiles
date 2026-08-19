{ ... }:
{
	home.username = "arnau";
	home.homeDirectory = "/Users/arnau";
	home.stateVersion = "26.05";

	programs.home-manager.enable = true;

	programs.nixvim = {
		enable = true;
		imports = [ ./nvim ];
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
