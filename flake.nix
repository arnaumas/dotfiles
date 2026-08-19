{
	description = "home-manager configuration";

	inputs = {
		nixpkgs = {
			type = "github";
			owner = "nixos";
			repo = "nixpkgs";
			ref = "nixos-unstable";
		};

		home-manager = {
			type = "github";
			owner = "nix-community";
			repo = "home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvim = {
			type = "path";
			path = "./nvim";
		};

		nixvim.follows = "nvim/nixvim";
	};

	outputs =
		{ self, nixpkgs, home-manager, nixvim, nvim, ... }:
		let
			system = "aarch64-darwin";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeModules.default = {
				imports = [ ./home.nix nixvim.homeModules.nixvim ];
				_module.args.themes = import ./themes.nix;
			};

			homeConfigurations.arnau = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ self.homeModules.default ];
			};

			checks.${system}.home = self.homeConfigurations.arnau.activationPackage;
		};
}
