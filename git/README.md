# git

Verbatim git config dropped into `~/.config/git/` via `xdg.configFile` (no `programs.git` module).

## Tree

```
default.nix   xdg.configFile: git/config + git/ignore
config        user (Arnau Mas, arnau.mas@outlook.com), color ui, editor nvim, git-lfs filter,
              excludesfile -> ~/.config/git/ignore, + the rest of the git settings
ignore        global ignore: .DS_Store, *.swp, LaTeX build products (*.aux/*.log/*.synctex.gz/…),
              .claude/, topic-manager project.toml manifests
```

## Notes

- `git` here means the config only; the `git` binary comes from the darwin/system layer
  (`~/home/darwin` systemPackages / Homebrew).
- nvim's in-editor git is separate (`mini.git`, in `nvim/git/`).
