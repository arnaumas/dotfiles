{ pkgs, ... }:
{
  # pi coding agent (pi.dev) — first-party nixpkgs package, BYOK.
  # Auth (/login) and model (/model) are interactive at runtime; they persist to
  # ~/.pi/agent/auth.json and ~/.pi/agent/settings.json (NOT managed here, so the
  # runtime writes are not clobbered).
  home.packages = [ pkgs.pi-coding-agent ];

  # Drop the ANSI "edge" theme into pi's custom-theme dir so pi discovers it.
  # pi scans ~/.pi/agent/themes/*.json; the "name" field ("edge") is what you
  # select once with /theme edge (persisted to settings.json, like /model).
  home.file.".pi/agent/themes/edge.json".source = ./edge.json;
}
