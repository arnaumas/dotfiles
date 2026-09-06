{ lib, ... }:
{
  programs.zsh = {
    defaultKeymap = "viins";

    initContent = lib.mkAfter (builtins.readFile ./vi.zsh + "\n" + builtins.readFile ./expand.zsh);
  };
}
