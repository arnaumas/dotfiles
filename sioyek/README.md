# sioyek

Purpose: Configuration for sioyek, the PDF reader wired as vimtex's previewer for the
LaTeX-centric Neovim setup. The configuration anchors sioyek's colors to the terminal
ANSI palette, rebinds navigation to vi-style keys, and constrains startup so opening a
document from Finder shows only that document.

## Layout and deployment

This is a stow package. Its tree mirrors the install target:

```
sioyek/.config/sioyek/prefs_user.config  →  ~/.config/sioyek/prefs_user.config
sioyek/.config/sioyek/keys_user.config   →  ~/.config/sioyek/keys_user.config
```

sioyek reads its runtime state from `~/Library/Application Support/sioyek/` on macOS.
That directory holds the databases (`local.db`, `shared.db`) and the launch-state file
(`last_document_path.txt`); it is not part of this package.

## Files

### prefs_user.config

Visual and behavioral preferences. Each color is RGB scaled `0.0`–`1.0`. The hex values
behind these triples live in `colors/light.yaml`, the single source of truth for the
terminal-anchored 16-color palette.

#### Fonts and sizing

| Setting | Value | Description |
|---------|-------|-------------|
| `ui_font` | `Geist Mono` | Font for UI elements (command bar, menus, table of contents) |
| `font_size` | `11` | UI font size |
| `status_bar_font_size` | `11` | Status bar font size |

NOTE: The status bar font family is not configurable in sioyek; the status bar renders
in sioyek's built-in font. Only `status_bar_font_size` changes the status bar.

#### UI chrome colors

| Setting | RGB | Palette slot |
|---------|-----|--------------|
| `background_color` | `0.980 0.980 0.980` | background `#fafafa` |
| `page_separator_color` | `0.933 0.945 0.957` | ANSI 15 `#eef1f4` |
| `ui_background_color` | `0.933 0.945 0.957` | ANSI 15 `#eef1f4` |
| `ui_text_color` | `0.294 0.314 0.357` | foreground `#4b505b` |
| `ui_selected_background_color` | `0.667 0.694 0.741` | ANSI 8 `#aab1bd` |
| `ui_selected_text_color` | `0.294 0.314 0.357` | foreground `#4b505b` |
| `status_bar_color` | `0.933 0.945 0.957` | ANSI 15 `#eef1f4` |
| `status_bar_text_color` | `0.294 0.314 0.357` | foreground `#4b505b` |
| `keyboard_select_background_color` | `0.478 0.678 0.200` | ANSI 10 `#7aad33` |
| `keyboard_select_text_color` | `0.980 0.980 0.980` | background `#fafafa` |
| `keyboard_select_font_size` | `9` | Font size of keyboard-select labels |

#### Page overlay colors

| Setting | RGB(A) | Palette slot |
|---------|--------|--------------|
| `text_highlight_color` | `0.667 0.694 0.741` | ANSI 8 `#aab1bd` |
| `link_highlight_color` | `0.314 0.475 0.745` | ANSI 4 `#5079be` |
| `visual_mark_color` | `0.314 0.475 0.745 0.15` | ANSI 4 `#5079be`, alpha `0.15` |
| `search_highlight_color` | `0.878 0.588 0.000` | ANSI 11 `#e09600` |
| `synctex_highlight_color` | `0.988 0.878 0.580` | lightened amber of ANSI 11 |

`visual_mark_color` takes a fourth alpha component; the low alpha keeps the ruler band
transparent over text.

#### Named highlights

`add_highlight` (bound to `ah`) prompts for a highlight type `a`–`z`. The configured
types map onto the palette's bright accent slots:

| Setting | RGB | Palette slot |
|---------|-----|--------------|
| `highlight_color_a` | `0.878 0.588 0.000` | ANSI 11 yellow `#e09600` |
| `highlight_color_b` | `0.478 0.678 0.200` | ANSI 10 green `#7aad33` |
| `highlight_color_c` | `0.878 0.392 0.392` | ANSI 9 red `#e06464` |
| `highlight_color_d` | `0.310 0.541 0.878` | ANSI 12 blue `#4f8ae0` |
| `highlight_color_e` | `0.769 0.408 0.902` | ANSI 13 magenta `#c468e6` |
| `highlight_color_f` | `0.267 0.659 0.620` | ANSI 14 cyan `#44a89e` |

#### Behavior

| Setting | Value | Description |
|---------|-------|-------------|
| `collapsed_toc` | `1` | Open the table of contents collapsed to top-level entries |
| `should_launch_new_window` | `1` | Open each document in its own window |
| `startup_commands` | `toggle_statusbar` | Hide the status bar at launch |

Showing only the opened document at startup depends on the launch-state file. See
[Single-document startup](#single-document-startup).

### keys_user.config

vi-style rebindings layered over sioyek's defaults.

#### Document navigation

| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `h` | n | `move_right` | Pan the page right |
| `l` | n | `move_left` | Pan the page left |
| `<C-d>` | n | `next_page` | Next page |
| `<C-u>` | n | `previous_page` | Previous page |
| `d` | n | `toggle_two_page_mode` | Toggle single/dual page layout |
| `^` | n | `goto_mark` | Jump to a set mark |
| `<C-r>` | n | `reload_config` | Reload `prefs_user.config` and `keys_user.config` |

#### Menu navigation

The `[m]` prefix scopes a binding to menu context (command palette, table of contents,
search results).

| Key | Command | Description |
|-----|---------|-------------|
| `<C-j>` | `control_menu(down)` | Move selection down |
| `<C-k>` | `control_menu(up)` | Move selection up |
| `<C-h>` | `control_menu(left)` | Collapse / move selection left |
| `<C-l>` | `control_menu(right)` | Expand / move selection right |

#### Highlights and selection

| Key | Command | Description |
|-----|---------|-------------|
| `ah` | `add_highlight` | Add a highlight of a chosen type |
| `xh` | `delete_highlight` | Delete the highlight under the cursor |
| `v` | `enter_visual_mark_mode` | Enter visual mark mode |
| `<C-v>` | `keyboard_select` | Keyboard-driven text selection |

## Color palette

Every color mirrors `colors/light.yaml`. To change a color, edit that file first, then
propagate the slot meaning here and across the other consumers (ghostty theme, iTerm
profile, nvim slot mapping, zsh UIs). Do not introduce hex values that have no
corresponding palette slot.

## Single-document startup

Opening a file from Finder launches sioyek through a LaunchServices open-document event
rather than a command-line argument. With an empty argument list, sioyek opens the file
recorded on the first line of `last_document_path.txt` and then opens the file from the
event, producing two windows.

The launch-state file is pinned to a non-existent path and made immutable so sioyek
cannot repopulate it. On startup sioyek reads the pinned path, fails to open it, and
shows only the document from the open-document event.

Setup on a new machine:

```bash
f=~/Library/Application\ Support/sioyek/last_document_path.txt
printf '/dev/null/__sioyek_no_restore__.pdf\n' > "$f"
chflags uchg "$f"
```

To undo, clear the immutable flag:

```bash
chflags nouchg ~/Library/Application\ Support/sioyek/last_document_path.txt
```

A non-existent path is required rather than an empty file: an empty file makes sioyek
fall back to the bundled tutorial PDF, while an unresolvable path opens nothing.

## Navigation

- [Repository root](../) — dotfiles overview and stow layout
- [CLAUDE.md](../CLAUDE.md) — repository conventions and design bias
- [colors/light.yaml](../colors/light.yaml) — terminal-anchored color palette
