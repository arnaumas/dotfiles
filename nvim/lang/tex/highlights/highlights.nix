# LaTeX capture highlights (math, links, latex-specific keywords).
{ palette, ... }:
{
  colors.groups = {
    "@operator.math".fg = palette.blue;
    "@markup.math".link = "Normal";
    "@markup.math.symbol".fg = palette.fg;
    "@punctuation.math".fg = palette.magenta;
    "@markup.link.tex".fg = palette.cyan;
    "@markup.link.path" = {
      fg = palette.cyan;
      underline = true;
    };
    "@punctuation.backslash".link = "Delimiter";
    "@keyword.import.latex".link = "Function";
    "@keyword.conditional.latex".link = "Function";
    "@module.latex".link = "Function";
    "@label.latex".link = "Normal";
  };
}
