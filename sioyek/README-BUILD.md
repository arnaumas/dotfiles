# Building sioyek from source (macOS)

Purpose: Reproduce the sioyek install on macOS. sioyek ships no prebuilt binary for the
`development` branch, so the reader's features (for example `page_labels_in_table_of_contents`)
require a source build. This document records the dependencies, source, build phases, and
bundle-assembly steps as a single ordered procedure, grouped so each phase maps onto a Nix
derivation attribute.

Runtime configuration lives in [README.md](README.md); this file covers only building and
installing the application.

## Result

A self-contained `sioyek.app` (~135 MB with bundled Qt frameworks) installed at
`/Applications/sioyek.app`, plus a command-line launcher at `/usr/local/bin/sioyek`.

## Dependencies

| Role | Component | Source |
|------|-----------|--------|
| Toolchain | Xcode Command Line Tools | `xcode-select --install` |
| Build tool | Qt 6 (`qmake`, `macdeployqt`) | `brew install qt` |
| Runtime | `icu4c@78` | Homebrew keg (Qt links against it) |
| Bundled | MuPDF | git submodule of sioyek |
| Signing | `codesign`, `/usr/libexec/PlistBuddy` | macOS base system |

Qt provider determines whether ICU must be bundled by hand:

- **Homebrew Qt** links against a separate `icu4c@78` keg. `macdeployqt` does not relocate
  it, so the ICU dylibs are copied into the bundle manually (see [Install](#install)).
- **aqtinstall Qt** ships ICU inside its own `lib/` directory, which `macdeployqt` bundles
  automatically; the manual ICU copy is unnecessary.

The procedure below assumes Homebrew Qt.

## Source

```bash
git clone --recursive --branch development --depth=1 \
  https://github.com/ahrm/sioyek ~/sioyek_build
cd ~/sioyek_build
```

- Branch: `development`
- Reference revision: `8083a3bd1b2e0926df6704533bbaa29247cdb42b`
  ("Add the page_labels_in_table_of_contents config")
- Submodule: `mupdf`

## Build

MuPDF first, then sioyek against Qt 6.

```bash
export PATH="/opt/homebrew/opt/qt/bin:$PATH"

# MuPDF
cd mupdf && make HAVE_GLUT=no -j$(sysctl -n hw.ncpu) && cd ..

# Configure: set the deployment target to the host major version, then qmake
sed -Ei '' "s/QMAKE_MACOSX_DEPLOYMENT_TARGET.=.[0-9]+/QMAKE_MACOSX_DEPLOYMENT_TARGET = $(sw_vers -productVersion | cut -d. -f1)/" pdf_viewer_build_config.pro
qmake "CONFIG+=non_portable" "QMAKE_CXXFLAGS+=-Wno-implicit-function-declaration" pdf_viewer_build_config.pro

# Compile
make -j$(sysctl -n hw.ncpu)
```

`make` produces `sioyek.app` at the repository root containing only the compiled binary.

## Install

Bundle assembly is order-sensitive. The sequence is:

```
┌──────────────────────────────────────────────────────────────┐
│ 1. macdeployqt on the bare app                               │
│    Bundle Qt frameworks while MacOS/ holds only the binary.  │
└───────────────────────────┬──────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. Copy resources into Contents/MacOS                        │
│    shaders, *.config, tutorial.pdf                           │
└───────────────────────────┬──────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. Copy ICU dylibs into Contents/Frameworks                  │
└───────────────────────────┬──────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. Embed PATH into Info.plist                                │
└───────────────────────────┬──────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. codesign the whole bundle, once                           │
└───────────────────────────┬──────────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────────┐
│ 6. Replace /Applications/sioyek.app                          │
└──────────────────────────────────────────────────────────────┘
```

```bash
cd ~/sioyek_build
export PATH="/opt/homebrew/opt/qt/bin:$PATH"

# 1. Bundle Qt on the bare app
macdeployqt sioyek.app

# 2. Resources
app=sioyek.app/Contents/MacOS
cp -R pdf_viewer/shaders "$app/shaders"
cp pdf_viewer/prefs.config pdf_viewer/keys.config \
   pdf_viewer/prefs_user.config pdf_viewer/keys_user.config "$app/"
cp tutorial.pdf "$app/tutorial.pdf"

# 3. ICU (Homebrew Qt only)
fw=sioyek.app/Contents/Frameworks
cp /opt/homebrew/opt/icu4c@78/lib/libicuuc.78.dylib   "$fw/"
cp /opt/homebrew/opt/icu4c@78/lib/libicui18n.78.dylib "$fw/"
cp /opt/homebrew/opt/icu4c@78/lib/libicudata.78.dylib "$fw/"

# 4. Embed PATH so launches from Dock find shell tools
INFO=sioyek.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :LSEnvironment:PATH string $PATH" "$INFO" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c "Set :LSEnvironment:PATH $PATH" "$INFO"

# 5. Sign once, after every bundle modification
codesign --force --sign - --deep sioyek.app
codesign --verify --strict sioyek.app && echo "signature OK"

# 6. Clean install
rm -rf /Applications/sioyek.app
cp -R sioyek.app /Applications/sioyek.app
```

### Command-line launcher

```bash
cat > /usr/local/bin/sioyek <<'EOF'
#!/bin/sh
exec /Applications/sioyek.app/Contents/MacOS/sioyek "$@"
EOF
chmod +x /usr/local/bin/sioyek
```

## Constraints

These are the invariants that keep the bundle valid:

- **`macdeployqt` runs before resources are added.** `macdeployqt` runs `otool` on every
  file in `Contents/MacOS` and signs each one. Non-Mach-O files (`*.config`, `tutorial.pdf`,
  `shaders/*.fragment`) present at that point produce `is not an object file` and
  `code object is not signed at all` errors.
- **`codesign` runs exactly once, last.** Any copy, move, or delete inside the bundle
  invalidates a prior signature. Signing is the final step before installation.
- **`/Applications/sioyek.app` is removed before copying.** `cp -R src dest` into an
  existing directory nests `dest/sioyek.app` instead of replacing it, leaving the old
  binary in place and producing a `bundle format is ambiguous` codesign error.
- **Homebrew Qt requires the ICU copy.** Without the three `libicu*.78.dylib` files in
  `Contents/Frameworks`, launch fails with
  `dyld: Library not loaded: @executable_path/../Frameworks/libicuuc.78.dylib`.
- **`macdeployqt` emits `Cannot resolve rpath` warnings for `QtPdf` and
  `QtVirtualKeyboard`.** These modules are unused; the warnings are expected and harmless.

## Diagnostics

| Symptom | Cause | Resolution |
|---------|-------|------------|
| `dyld: Library not loaded: ...libicuuc.78.dylib` | ICU not bundled | Copy the three ICU dylibs into `Contents/Frameworks`, re-sign |
| `bundle format is ambiguous (could be app or framework)` | Nested `sioyek.app/sioyek.app`, or missing `CFBundlePackageType` | Remove the nested bundle / add `CFBundlePackageType string APPL`, re-sign |
| `is not an object file` during `macdeployqt` | Resources copied before `macdeployqt` | Deploy on the bare app, then add resources |
| Black page on launch | `shaders/` missing from `Contents/MacOS` | Copy `pdf_viewer/shaders`, re-sign |

Config keys are stored as wide strings (`L"..."`). Plain `strings` cannot find them; verify
an option exists in the binary against the source registration in `pdf_viewer/config.cpp`.

## Updating

Repeat [Source](#source) through [Install](#install) with the latest `development` branch.
An existing checkout updates in place, though the original `--depth=1` clone makes `git pull`
awkward; a fresh clone is the reliable path.

## Toward a Nix flake

The phases above map directly onto a `stdenv.mkDerivation` on `aarch64-darwin`:

| Procedure phase | Derivation attribute |
|-----------------|----------------------|
| [Source](#source) | `src = fetchFromGitHub { owner = "ahrm"; repo = "sioyek"; rev; hash; fetchSubmodules = true; }` |
| Xcode CLT, Qt tools | `nativeBuildInputs = [ qt6.qmake qt6.wrapQtAppsHook ]` |
| Qt, ICU, MuPDF deps | `buildInputs = [ qt6.qtbase icu mupdf freetype harfbuzz ]` |
| MuPDF + qmake + make | `buildPhase` |
| Bundle assembly | `installPhase` producing `$out/Applications/sioyek.app` |
| Launcher | `installPhase` writing `$out/bin/sioyek` |

Under Nix the manual steps collapse:

- **ICU** is a normal `buildInput`; `wrapQtAppsHook` and the Nix store's closure handle
  linkage, so the manual `libicu*` copy is unnecessary.
- **Code signing** is ad-hoc on `aarch64-darwin`; `fixupPhase` handles it, so the explicit
  `codesign` step is unnecessary.
- **`Info.plist` PATH embedding** is replaced by `wrapQtAppsHook`, which wraps the
  executable with the correct environment.

`nixpkgs` already packages sioyek; a flake tracking `development` overrides that derivation's
`src` (and `version`) with the pinned `rev` and `hash` rather than defining the build from
scratch.

## Related

- [README.md](README.md) — runtime configuration and keybindings
- [ahrm/sioyek discussion #1602](https://github.com/ahrm/sioyek/discussions/1602) — upstream macOS build notes
- [Repository root](../) — dotfiles overview
