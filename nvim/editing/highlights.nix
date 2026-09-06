# treesitter capture highlights.
{
  lib,
  palette,
  hl,
  ...
}:
{
  colors.groups = lib.mkMerge [
    (hl.clear [
      "@function.call"
      "@function.builtin"
      "@function.method.call"
      "@keyword"
      "@conditional"
      "@repeat"
      "@variable"
      "@variable.parameter"
      "@variable.member"
      "@property"
      "@field"
      "@type"
      "@type.builtin"
      "@module"
      "@namespace"
      "@tag.attribute"
    ])
    (hl.linkTo "Constant" [
      "@constant"
      "@constant.builtin"
      "@constant.macro"
    ])
    (hl.linkTo "Function" [
      "@function"
      "@function.method"
      "@constructor"
    ])
    (hl.linkTo "Delimiter" [
      "@operator"
      "@punctuation.delimiter"
      "@punctuation.bracket"
      "@punctuation.special"
      "@tag.delimiter"
    ])
    (hl.linkTo "UiMuted" [
      "@label"
      "@markup.list"
    ])
    {
      "@comment".link = "Comment";
      "@string".link = "String";
      "@character".link = "Character";
      "@number".link = "Number";
      "@boolean".link = "Boolean";
      "@tag".link = "Tag";

      "@comment.error" = {
        fg = palette.red;
        bold = true;
      };
      "@comment.warning" = {
        fg = palette.yellow;
        bold = true;
      };
      "@comment.todo" = {
        fg = palette.blue;
        bold = true;
      };
      "@comment.note" = {
        fg = palette.cyan;
        bold = true;
      };
      "@string.escape".fg = palette.cyan;
      "@string.special".fg = palette.cyan;
      "@variable.builtin".fg = palette.magenta;
      "@type.definition".fg = palette.blue;
      "@attribute".fg = palette.cyan;
      "@markup.heading" = {
        fg = palette.blue;
        bold = true;
      };
      "@markup.strong".bold = true;
      "@markup.italic".italic = true;
      "@markup.link" = {
        fg = palette.blue;
        underline = true;
      };
      "@markup.raw".fg = palette.green;
      "@markup.quote" = {
        fg = palette.dim_fg;
        italic = true;
      };
    }
  ];
}
