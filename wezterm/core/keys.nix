{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  mod = "NONE|SUPER|CMD|CTRL|SHIFT|ALT|OPT|LEADER";
  keyType = types.submodule {
    options = {
      key = mkOption { type = types.str; };
      mods = mkOption {
        type = types.strMatching "(${mod})(\\|(${mod}))*";
        default = "NONE";
      };
      action = mkOption {
        type = types.either types.str (
          types.addCheck (types.attrsOf types.anything) (a: builtins.length (builtins.attrNames a) == 1)
        );
      };
    };
  };
in {
  options.programs.wezterm.keys = mkOption {
    type = types.listOf keyType;
    default = [ ];
  };

  config.programs.wezterm = {
    settings = {
      leader = {
        key = "a";
        mods = "CTRL";
      };
      keys = config.programs.wezterm.keys;
    };
    keys = [
      {
        key = "r";
        mods = "LEADER";
        action = "ReloadConfiguration";
      }
      {
        key = "a";
        mods = "LEADER|CTRL";
        action.SendKey = {
          key = "a";
          mods = "CTRL";
        };
      }
    ];
  };
}
