{
	description = "nixvim configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixvim.url = "github:nix-community/nixvim";
	};

	outputs =
		{ self, nixpkgs, nixvim }:
		let
			system = "aarch64-darwin";
			pkgs = nixpkgs.legacyPackages.${system};
		in
		{
			packages.${system}.default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
				inherit pkgs;
				module = ./.;
			};

			checks.${system}.default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
				nvim = self.packages.${system}.default;
				name = "nvim-check";
			};
		};
}
