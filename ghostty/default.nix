{ colors, lib, ... }:

let
	light = colors.light;
	dark = colors.dark;

	# ghostty wants palette as repeated `N=#hex` lines -> list of strings.
	mkPalette = c: [
		"0=${c.black}"   "1=${c.red}"      "2=${c.green}"   "3=${c.yellow}"
		"4=${c.blue}"    "5=${c.magenta}"  "6=${c.cyan}"    "7=${c.white}"
		"8=${c.blackBg}" "9=${c.redBg}"    "10=${c.greenBg}" "11=${c.yellowBg}"
		"12=${c.blueBg}" "13=${c.magentaBg}" "14=${c.cyanBg}" "15=${c.whiteBg}"
	];
in
{
	programs.ghostty = {
		enable = true;

		# TODO(verify): ghostty's nixpkgs package does not build on darwin.
		# Set null and keep the brew-installed binary; module still writes config.
		package = null;

		settings = {
			font-family = "Geist Mono";
			font-size = 12;
			font-feature = [ "-calt" "-liga" "-dlig" "+kern" ];
			font-thicken = true;
			font-thicken-strength = 60;
			adjust-underline-position = 3;
			adjust-cell-height = -1;

			theme = "light:light,dark:dark";

			quick-terminal-position = "center";
			quick-terminal-size = "30%,30%";

			cursor-color = "cell-foreground";
			cursor-text = "cell-background";

			confirm-close-surface = false;

			window-inherit-working-directory = true;
			window-save-state = "always";
			macos-titlebar-style = "hidden";
			macos-titlebar-proxy-icon = "hidden";
			window-padding-x = 4;
			window-padding-y = "10,2";
		};

		# TODO(verify): themes schema. Each theme is a settings attrset;
		# palette is the list form above. Confirm key name is `themes`.
		themes = {
			light = {
				foreground = light.termFg;
				background = light.termBg;
				selection-background = light.white;
				selection-foreground = light.termFg;
				cursor-color = light.cursor;
				cursor-text = light.cursorText;
				palette = mkPalette light;
			};

			dark = {
				foreground = dark.termFg;
				background = dark.termBg;
				selection-background = dark.white;
				selection-foreground = dark.termFg;
				selection-invert-fg-bg = false;
				cursor-color = "cell-foreground";
				cursor-text = "cell-background";
				split-divider-color = "#878787";  # TODO: pull into colors.nix?
				palette = mkPalette dark;
			};
		};
	};
}
