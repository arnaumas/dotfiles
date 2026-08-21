{
	description = "nvim configuration";

	inputs = {
		nixpkgs = {
			type = "github";
			owner = "nixos";
			repo = "nixpkgs";
			ref = "nixos-unstable";
		};

		nixvim = {
			type = "github";
			owner = "nix-community";
			repo = "nixvim";
		};
	};

	outputs = { self, nixpkgs, nixvim, ... }:
    let
			lib = nixpkgs.lib;
      systems = [ "aarch64-darwin" "x86_64-linux" ];
      forEach = lib.genAttrs systems;
			pkgsFor = system: nixpkgs.legacyPackages.${system};

    in {
      # home-manager submodule
			homeModules.default = {
        imports = [ nixvim.homeModules.nixvim ];
        programs.nixvim.imports = [ ./. ] ;
      };

			# standalone system agnostic neovim package
			packages = forEach (system: {
				default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
					pkgs = pkgsFor system;
					module = ./.;
				};
			});

			# checks
			checks = forEach (system: {
				nvim = nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule {
					pkgs = pkgsFor system;
					module = ./.;
				};
			});
		};
}
