{
	description = "nixvim configuration (home-manager-ready)";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixvim.url = "github:nix-community/nixvim";
		nixvim.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs =
		{ self, nixpkgs, nixvim }:
		let
			# single system for now (this machine). add more when needed.
			system = "aarch64-darwin";
			pkgs = nixpkgs.legacyPackages.${system};
		in
		{
			# `nix run .#default` builds and runs the whole config.
			# NOTE: the ONLY nixvim-standalone-specific wiring is this block.
			# migrating to home-manager = delete this, add `programs.nixvim.imports = [ ./nvim/modules ];`
			# everything under ./nvim/modules moves over unchanged.
			packages.${system}.default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
				inherit pkgs;
				module = ./nvim/modules;
			};

			# `nix flake check` evaluates the config without launching it.
			checks.${system}.default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
				nvim = self.packages.${system}.default;
				name = "nvim-check";
			};
		};
}
