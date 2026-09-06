# The `ansi` colorscheme machinery: the `colors.groups` option, the renderer
# that turns it into colors/ansi.lua, and the group-building helpers exposed to
# every module as the `hl` arg. The groups themselves live in per-concern
# highlights.nix files (core's own in ./highlights.nix).
#
# `termguicolors` is OFF (ui/), so groups carry integer `fg`/`bg` = ANSI slots
# 0-15 (from `palette`), emitted as `ctermfg`/`ctermbg`. Links resolve by name
# at runtime, so contribution order is irrelevant.
{ lib, config, ... }:
let
  luaStr = s: ''"'' + s + ''"'';

  boolAttrs = {
    bold = "bold";
    italic = "italic";
    underline = "underline";
    undercurl = "undercurl";
    strike = "strikethrough";
  };

  renderGroup =
    name: g:
    let
      body =
        if g.link != null then
          [ "link = ${luaStr g.link}" ]
        else
          (lib.optional (g.fg != null) "ctermfg = ${toString g.fg}")
          ++ (lib.optional (g.bg != null) "ctermbg = ${toString g.bg}")
          ++ (lib.mapAttrsToList (_field: key: "${key} = true") (
            lib.filterAttrs (field: _: g.${field}) boolAttrs
          ));
    in
    "vim.api.nvim_set_hl(0, ${luaStr name}, { ${lib.concatStringsSep ", " body} })";

  mkAnsi =
    groups:
    lib.concatStringsSep "\n" (
      [
        "vim.cmd('highlight clear')"
        "if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end"
        "vim.g.colors_name = 'ansi'"
        ""
      ]
      ++ lib.mapAttrsToList renderGroup groups
    )
    + "\n";

  groupType = lib.types.submodule {
    options = {
      fg = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      bg = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      bold = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      italic = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      underline = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      undercurl = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      strike = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      link = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  # group-building helpers: same spec for a list of names.
  clear = names: lib.genAttrs names (_: { });
  linkTo =
    to: names:
    lib.genAttrs names (_: {
      link = to;
    });
  withFg =
    c: names:
    lib.genAttrs names (_: {
      fg = c;
    });

in
{
  options.colors.groups = lib.mkOption {
    type = lib.types.attrsOf groupType;
    default = { };
    description = "Highlight groups, rendered into colors/ansi.lua at build.";
  };

  config = {
    _module.args.hl = { inherit clear linkTo withFg; };

    colorscheme = "ansi";
    extraFiles."colors/ansi.lua".text = mkAnsi config.colors.groups;
  };
}
