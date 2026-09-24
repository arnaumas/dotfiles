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

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nvim,
      ...
    }:
    let
      lib = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forEach = lib.genAttrs systems;
      mkHomeFor =
        f:
        lib.listToAttrs (
          map (system: {
            name = "arnau@${system}";
            value = f system;
          }) systems
        );
      pkgsFor = system: nixpkgs.legacyPackages.${system};
      homeDir = system: if lib.hasSuffix "darwin" system then "/Users/arnau" else "/home/arnau";

    in
    {
      # home-manager submodule
      homeModules.default = {
        imports = [
          ./home.nix
          nvim.homeModules.default
          nvim.homeModules.manpager
          nvim.homeModules.zle
        ];
      };

      # standalone system agnostic home configs
      homeConfigurations = mkHomeFor (
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = {
            theme = import ./theme.nix;
          };
          modules = [
            {
              home = {
                username = "arnau";
                homeDirectory = homeDir system;
                stateVersion = "26.05";
              };
            }
            self.homeModules.default
          ];
        }
      );

      # checks
      checks = forEach (
        system:
        let
          pkgs = pkgsFor system;
          zdotdir = "${self.homeConfigurations."arnau@${system}".config.home-files}/.config/zsh";

          # headless zsh startup check: parse the generated rc and source it once,
          # failing on real startup errors (benign sandbox noise is ignored).
          zshCheck =
            pkgs.runCommandLocal "zsh-startup-check"
              {
                nativeBuildInputs = [ pkgs.zsh ];
              }
              ''
                # parse-check every line we author (readFile-inlined -> all in .zshrc)
                        zsh -n ${zdotdir}/.zshrc

                # source the real rc in an interactive shell; discard stdout, keep stderr
                        export HOME=$(mktemp -d)
                        export XDG_CACHE_HOME=$HOME/.cache XDG_CONFIG_HOME=$HOME/.config
                        mkdir -p $XDG_CACHE_HOME/zsh
                        export ZDOTDIR=${zdotdir} TERM=xterm

                        err=$(zsh -i -c exit 2>&1 1>/dev/null) || true
                        bad=$(printf '%s\n' "$err" | grep -Ei 'bad substitution|parse error|not found|no such file|syntax error' || true)
                        [ -z "$bad" ] || { printf 'zsh startup errors:\n%s\n' "$bad" >&2; exit 1; }

                    touch $out
              '';
        in
        {
          home = pkgs.runCommandLocal "dotfiles-check" { } ''
            echo ${self.homeConfigurations."arnau@${system}".activationPackage} > $out
            echo ${nvim.checks.${system}.nvim} >> $out
            echo ${zshCheck} >> $out
          '';
        }
      );
    };
}
