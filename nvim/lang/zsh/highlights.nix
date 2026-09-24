{ lib, palette, hl, ... }:
let
  p = palette;
  zsh = map (c: "@${c}.zsh");
  
in {
  extraFiles."after/queries/zsh/highlights.scm".source = ./highlights.scm;
  extraConfigLua = builtins.readFile ./commands.lua;

  colors.groups = lib.mkMerge [
    { zshFunction.fg = p.blue; }
    (hl.withFg p.blue (zsh [
      "function"
      "function.call"
      "function.builtin"
    ]))
    (hl.withFg p.yellow (zsh [
      "comment"
      "keyword.directive"
    ]))
    (hl.linkTo "Normal" (zsh [
      "operator"
      "punctuation.bracket"
      "punctuation.delimiter"
      "punctuation.special"
      "label"
      "keyword"
      "keyword.conditional"
      "keyword.conditional.ternary"
      "keyword.repeat"
      "keyword.import"
      "keyword.function"
      "variable"
      "variable.builtin"
      "variable.parameter"
      "constant"
      "constant.builtin"
      "boolean"
      "number"
      "attribute.builtin"
    ]))
    {
      "@string.regexp.zsh".fg = p.cyan;
      "@string.special.path.zsh".underline = true;
    }
  ];
}
