{ pkgs, ... }:
{
  # pi coding agent (pi.dev) — first-party nixpkgs package, BYOK.
  # Config (login/model) is interactive at runtime: run `pi`, then `/login`, `/model`.
  home.packages = [ pkgs.pi-coding-agent ];
}
