{
	description = "home-manager configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		nvim.url = "path:./nvim";
		nixvim.follows = "nvim/nixvim";
	};

	outputs =
		{ self, nixpkgs, home-manager, nixvim, nvim, ... }:
		let
			system = "aarch64-darwin";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations.arnau = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ ./home.nix nixvim.homeModules.nixvim ];
			};

			checks.${system}.home = self.homeConfigurations.arnau.activationPackage;
		};
}
