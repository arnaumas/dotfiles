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
		./sioyek
		./ghostty 
	];
}
