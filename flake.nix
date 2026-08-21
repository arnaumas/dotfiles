{
	description = "dotfiles";

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
	};

	outputs = inputs@{ self, nixpkgs, home-manager, nvim, ... }:
		let
			lib = nixpkgs.lib;
			systems = [ "aarch64-darwin" "x86_64-linux" ];
			forEach = lib.genAttrs systems;
			mkHomeFor = f: lib.listToAttrs (map (system: {
				name = "arnau@${system}";
				value = f system;
			}) systems);
			pkgsFor = system: nixpkgs.legacyPackages.${system};
			homeDir = system: if lib.hasSuffix "darwin" system then "/Users/arnau" else "/home/arnau";

		in {
			# home-manager submodule
			homeModules.default = {
				imports = [ ./home.nix nvim.homeModules.default ];
			};

			# standalone system agnostic home configs
      homeConfigurations = mkHomeFor (system: home-manager.lib.homeManagerConfiguration {
				pkgs = pkgsFor system;
				extraSpecialArgs = { theme = import ./theme.nix; };
				modules = [
					{home = { username = "arnau"; homeDirectory = homeDir system; stateVersion = "26.05"; };}
					self.homeModules.default
				];
			});

			# checks
			checks = forEach (system: {
				home = (pkgsFor system).runCommandLocal "dotfiles-check" { } ''
					echo ${self.homeConfigurations."arnau@${system}".activationPackage} > $out
					echo ${nvim.checks.${system}.nvim} >> $out
				'';
			});
		};
}

