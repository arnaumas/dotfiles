# nvim-tree highlights.
{ lib, palette, hl, ... }:
{
  colors.groups = lib.mkMerge [
    {
      NvimTreeNormal.link = "UiSurface";
      NvimTreeEnOfBuffer.link = "NvimTreeNormal";
      NvimTreeRootFolder.link = "UiAccent";
      NvimTreeIndentMarker.link = "UiMuted";
      NvimTreeCursorLine.link = "UiSelected";
      NvimTreeStatusLine.link = "NvimTreeNormal";
      NvimTreeStatuslineNC.link = "NvimTreeNormal";
			NvimTreeWinseparator.fg = palette.dim_bg;
      NvimTreeSymlink.fg = palette.magenta;
      NvimTreeExecFile.fg = palette.red;
      NvimTreeSpecialFile.link = "NvimTreeNormal";
      NvimTreeOpenedHl.link = "UiAccent";
    }
    (hl.linkTo "Directory" [
      "NvimTreeFolderName"
      "NvimTreeFolderIcon"
      "NvimTreeOpenedFolderName"
      "NvimTreeEmptyFolderName"
    ])
    (hl.linkTo "UiMuted" [
      "NvimTreeGitDirtyIcon"
      "NvimTreeGitStagedIcon"
      "NvimTreeGitNewIcon"
      "NvimTreeGitDeletedIcon"
      "NvimTreeGitRenamedIcon"
      "NvimTreeGitMergeIcon"
      "NvimTreeGitIgnoredIcon"
    ])
  ];
}
