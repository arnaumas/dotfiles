# semantic-token, diagnostic and LSP-feature highlights.
{
  lib,
  palette,
  hl,
  ...
}:
let
  sevs = [
    "Error"
    "Warn"
    "Info"
    "Hint"
  ];
  kinds = [
    "Sign"
    "VirtualText"
    "Floating"
  ];
  underlines = lib.genAttrs (map (s: "DiagnosticUnderline${s}") sevs) (_: {
    undercurl = true;
  });
  sevKinds = lib.listToAttrs (
    lib.concatMap (
      s: map (k: lib.nameValuePair "Diagnostic${k}${s}" { link = "Diagnostic${s}"; }) kinds
    ) sevs
  );
in
{
  colors.groups = lib.mkMerge [
    (hl.clear [
      "@lsp.type.function"
      "@lsp.type.method"
      "@lsp.type.parameter"
      "@lsp.type.variable"
      "@lsp.type.property"
      "@lsp.type.namespace"
      "@lsp.type.keyword"
    ])
    (hl.linkTo "Function" [
      "@lsp.typemod.function.declaration"
      "@lsp.typemod.method.declaration"
    ])
    (hl.linkTo "Constant" [
      "@lsp.type.enumMember"
      "@lsp.typemod.variable.readonly"
    ])
    (lib.genAttrs
      [
        "LspReferenceText"
        "LspReferenceRead"
        "LspReferenceWrite"
      ]
      (_: {
        bg = palette.bg;
      })
    )
    underlines
    sevKinds
    {
      "@lsp.type.string".link = "String";
      "@lsp.type.number".link = "Number";
      "@lsp.type.comment".link = "Comment";

      DiagnosticError.fg = palette.red;
      DiagnosticWarn.fg = palette.yellow;
      DiagnosticInfo.fg = palette.blue;
      DiagnosticHint.fg = palette.cyan;
      DiagnosticOk.fg = palette.green;
      DiagnosticDeprecated.underline = true;

      LspInlayHint.link = "UiMuted";
      LspCodeLens.link = "UiMuted";
      LspSignatureActiveParameter = {
        fg = palette.yellow;
        bold = true;
      };
    }
  ];
}
