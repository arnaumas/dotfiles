{ .. }: {
	programs.bat = {
		enable = true;
		config.theme = "ansi16";
		themes.ansi16 = builtins.readFile ./ansi16.tmThemes;
	};
}
