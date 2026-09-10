{
  lib,
  palette,
  hl,
  ...
}:
let
  p = palette;
in
{
  colors.groups = lib.mkMerge [
    # Ui* surface units
    {
      UiMuted.fg = p.dim_fg;
      UiSurface = {
        fg = p.fg;
        bg = p.dim_bg;
      };
      UiSurfaceMuted = {
        fg = p.dim_fg;
        bg = p.dim_bg;
      };
      UiSelected = {
        fg = p.fg;
        bg = p.bg;
        bold = true;
      };
      UiAccent = {
        fg = p.accent;
        bold = true;
      };
      UiAccentBg = {
        fg = p.fg;
        bg = p.accent_bg;
        bold = true;
      };
    }

    # editor UI
    (hl.clear [
      "Normal"
      "NormalNC"
      "SignColumn"
      "Folded"
      "TabLineFill"
    ])
    (hl.linkTo "UiMuted" [
      "EndOfBuffer"
      "LineNr"
      "LineNrAbove"
      "LineNrBelow"
      "FoldColumn"
      "WinSeparator"
      "VertSplit"
      "NonText"
      "Whitespace"
      "SpecialKey"
      "Conceal"
      "ModeMsg"
      "MsgSeparator"
    ])
    {
      CursorLine.bg = p.dim_bg;
      CursorLineNr.link = "UiAccent";
      CursorColumn.bg = p.dim_bg;
      ColorColumn.bg = p.bg;
      FoldEllipsis = {
        fg = p.dim_fg;
        bg = p.bg;
        bold = true;
      };

      Visual = {
        fg = p.selection_fg;
        bg = p.selection_bg;
      };
      VisualNOS.link = "Visual";

      Search = {
        fg = p.yellow;
        bg = p.bg;
        bold = true;
      };
      IncSearch = {
        fg = p.yellow;
        bg = p.yellow_bg;
        bold = true;
      };
      CurSearch.link = "IncSearch";
      MatchParen = {
        fg = p.accent;
        bold = true;
        underline = true;
      };

      Pmenu.link = "UiSurfaceMuted";
      PmenuSel.link = "UiSelected";
      PmenuSbar.link = "Pmenu";
      PmenuThumb.link = "Pmenu";
      PmenuKind.fg = p.blue;
      PmenuExtra.fg = p.dim_fg;

      StatusLine.link = "UiSurface";
      StatusLineNC.link = "UiSurfaceMuted";
      TabLine = {
        fg = p.dim_fg;
        bg = p.bg;
      };
      TabLineSel.link = "UiAccentBg";
      WildMenu.link = "UiAccentBg";
      WinBarNC = {
        fg = p.dim_fg;
        bg = p.bg;
      };

      NormalFloat.link = "UiSurface";
      FloatBorder.bg = p.dim_bg;
      FloatTitle = {
        bg = p.bg;
        bold = true;
      };
      WinBar.link = "FloatTitle";

      Title = {
        fg = p.blue;
        bold = true;
      };
      Directory.fg = p.blue;
      QuickFixLine = {
        bg = p.bg;
        bold = true;
      };
      ErrorMsg.fg = p.red;
      WarningMsg.fg = p.yellow;
      MoreMsg.fg = p.green;
      Question.fg = p.green;
    }
    (lib.genAttrs
      [
        "SpellBad"
        "SpellCap"
        "SpellRare"
        "SpellLocal"
      ]
      (_: {
        undercurl = true;
      })
    )

    # generic syntax
    (hl.clear [
      "Identifier"
      "Statement"
      "Keyword"
      "Conditional"
      "Repeat"
      "Label"
      "Exception"
      "PreProc"
      "Include"
      "Define"
      "Macro"
      "PreCondit"
      "Type"
      "StorageClass"
      "Structure"
      "Typedef"
    ])
    (hl.withFg p.green [
      "String"
      "Character"
      "Number"
      "Float"
    ])
    (hl.withFg p.magenta [
      "Boolean"
      "Constant"
    ])
    (hl.linkTo "Delimiter" [
      "Operator"
      "Special"
      "Debug"
    ])
    {
      Comment = {
        fg = p.yellow;
        italic = true;
      };
      Function.fg = p.blue;
      Tag.fg = p.blue;
      SpecialChar.fg = p.cyan;
      Delimiter.fg = p.dim_fg;
      Todo = {
        fg = p.yellow;
        bold = true;
      };
      Error.fg = p.red;
      Underlined = {
        fg = p.blue;
        underline = true;
      };
    }

    # generic diff
    {
      DiffAdd.fg = p.green;
      DiffChange.fg = p.yellow;
      DiffDelete.fg = p.red;
      DiffText = {
        fg = p.fg;
        bg = p.blue_bg;
      };
      MsgArea.link = "Normal";
    }
  ];
}
