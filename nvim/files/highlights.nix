# nvim-tree highlights.
{ lib, palette, hl, ... }:
{
  colors.groups = lib.mkMerge [
    {
      NvimTreeFolderName.link = "Directory";
      NvimTreeFolderIcon.link = "Directory";
      NvimTreeOpenedFolderName.link = "Directory";
      NvimTreeEmptyFolderName.link = "Directory";
      NvimTreeRootFolder.link = "UiAccent";
      NvimTreeIndentMarker.link = "UiMuted";
      NvimTreeCursorLine.link = "UiSelected";
      NvimTreeSymlink.fg = palette.magenta;
      NvimTreeExecFile.fg = palette.red;
      NvimTreeSpecialFile.link = "Normal";
      NvimTreeOpenedHl.link = "UiAccent";
    }
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
