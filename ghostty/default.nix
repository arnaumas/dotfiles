{ themes, lib, ... }:

let
	light = themes.light;
	dark = themes.dark;

	mkPalette = theme: [
		"0=${theme.black or theme.white}"   "1=${theme.red}"      "2=${theme.green}"   "3=${theme.yellow}"
		"4=${theme.blue}"    "5=${theme.magenta}"  "6=${theme.cyan}"    "7=${theme.grey}"
		"8=${theme.blackBg or theme.whiteBg}" "9=${theme.redBg}"    "10=${theme.greenBg}" "11=${theme.yellowBg}"
		"12=${theme.blueBg}" "13=${theme.magentaBg}" "14=${theme.cyanBg}" "15=${theme.greyBg}"
	];
in
{
	programs.ghostty = {
		enable = true;

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

		themes = {
			light = {
				foreground = light.uiFg;
				background = light.termBg;
				selection-background = light.uiBg;
				selection-foreground = light.uiFg;
				selection-invert-fg-bg = false;
				palette = mkPalette light;
			};

			dark = {
				foreground = dark.uiFg;
				background = dark.termBg;
				selection-background = dark.uiBg;
				selection-foreground = dark.uiBg;
				selection-invert-fg-bg = false;
				split-divider-color = "#878787";  
				palette = mkPalette dark;
			};
		};
	};
}
